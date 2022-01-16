Scriptname Mumirnik_Quest_Instincts_PetOptions extends Quest  
{The guts of the pet system. Handles pet taming and releasing, and manages pet slots and the slot cap.}

import Debug

Activator[] property PetHungerActivator auto
{MUST be at least 6 items. Hunger progression is hardcoded.}
ActorBase property EncWolfIce auto
{Used for special casing.}
ActorBase property EncWolfIcePet auto
{Used for special casing.}
FormList property OriginalRaceList auto
{List of races that can be turned into pets.}
FormList property PetActorList auto
{List of pet actors.}
GlobalVariable property PetCount auto
{Current number of pets.}
Message[] property TamedMessage auto
{Shown when a pet is tamed.}
Race property WolfRace auto
{Used for special casing.}
ReferenceAlias[] property PetREF auto
ReferenceAlias[] property PetHungerREF auto
Spell[] property HungerBuffSpell auto
{MUST be at least 6 items. Hunger progression is hardcoded.}

bool TimerIsRunning = false

ActorBase property TestWolf auto

function MakePet(Actor akTarget)
{This makes the target your pet, initializes its stats and starts the hunger time. Will throw if the target is an invalid race or there are no free pet slots.}
	Race originalRace = akTarget.GetRace()
	int originalRaceId = -1
	originalRaceId = OriginalRaceList.Find(originalRace)
	if (originalRaceId == -1)
		MessageBox("Error: Unknown actor race")
		return
	endIf

	ActorBase newActorBase = PetActorList.GetAt(originalRaceId) as ActorBase
	
	if (originalRace == WolfRace && akTarget.GetActorBase() == EncWolfIce)
		newActorBase = EncWolfIcePet ; special case for ice wolves which do not have a custom race but do have higher stats
	endIf
	
	akTarget.Disable()
	Actor petActor = akTarget.PlaceActorAtMe(TestWolf)

	int slotFilled = -1
	if (PetREF[0].GetReference() == NONE)
		PetREF[0].ForceRefTo(petActor)
		slotFilled = 0
	elseIf (PetREF[1].GetReference() == NONE)
		PetREF[1].ForceRefTo(petActor)
		slotFilled = 1
	elseIf (PetREF[2].GetReference() == NONE)
		PetREF[2].ForceRefTo(petActor)
		slotFilled = 2
	else
		MessageBox("Error: No free pet slot, PetCount = " + PetCount.GetValue() as Int + ", reverting")
		akTarget.Enable()
		petActor.Delete()
		return
	endIf

	petActor.StopCombat()
	petActor.SetPlayerTeammate(true, false)
	petActor.EvaluatePackage()

	PetCount.Mod(1)

	TamedMessage[slotFilled].Show()

	petActor.RestoreActorValue("Health", 10000)
	((self as Quest) as Mumirnik_Quest_Instincts_PetStats).SetHunger(akTarget, 50)
	((self as Quest) as Mumirnik_Quest_Instincts_PetTraining).InitTrainingProgression(akTarget)

	if (!TimerIsRunning)
		TimerIsRunning = true
		RegisterForSingleUpdateGameTime(1.0)
	endIf
endFunction

function ReleasePet(Actor akTarget)
{This releases your pet and clears the pet slot. Will throw if the pet is an invalid race or does not exist in a pet slot.}
	if (PetREF[0].GetReference() == akTarget)
		PetREF[0].Clear()
		PetHungerREF[0].Clear()
	elseIf (PetREF[1].GetReference() == akTarget)
		PetREF[1].Clear()
		PetHungerREF[1].Clear()
	elseIf (PetREF[2].GetReference() == akTarget)
		PetREF[2].Clear()
		PetHungerREF[2].Clear()
	else
		MessageBox("Error: Pet does not exist in any slot")
		return
	endIf

	akTarget.Delete()

;	petActor.StopCombat()
;	petActor.SetPlayerTeammate(false, false)
;	petActor.EvaluatePackage()

	PetCount.Mod(-1)

;	akTarget.RestoreActorValue("Health", 10000)
;	akTarget.SetActorValue("WaitingForPlayer", 0)
;	((self as Quest) as Mumirnik_Quest_Instincts_PetStats).RevertPetStatMultipliers(akTarget)
;	((self as Quest) as Mumirnik_Quest_Instincts_PetTraining).UndoTrainingProgression(akTarget)

;	akTarget.RemoveSpell(HungerBuffSpell[0])
;	akTarget.RemoveSpell(HungerBuffSpell[1])
;	akTarget.RemoveSpell(HungerBuffSpell[2])
;	akTarget.RemoveSpell(HungerBuffSpell[3])
;	akTarget.RemoveSpell(HungerBuffSpell[4])
;	akTarget.RemoveSpell(HungerBuffSpell[5])

	if (PetCount.GetValue() == 0 && TimerIsRunning)
		TimerIsRunning = false
		UnregisterForUpdateGameTime()
	endIf
endFunction

event OnUpdateGameTime()
	Actor pet1 = PetREF[0].GetReference() as Actor
	Actor pet2 = PetREF[1].GetReference() as Actor
	Actor pet3 = PetREF[2].GetReference() as Actor
	if (pet1)
		((self as Quest) as Mumirnik_Quest_Instincts_PetStats).UpdatePetStatsGameTime(pet1)
	endIf
	if (pet2)
		((self as Quest) as Mumirnik_Quest_Instincts_PetStats).UpdatePetStatsGameTime(pet2)
	endIf
	if (pet3)
		((self as Quest) as Mumirnik_Quest_Instincts_PetStats).UpdatePetStatsGameTime(pet3)
	endIf
	RegisterForSingleUpdateGameTime(1.0)
endEvent

ReferenceAlias function GetRefForActor(Actor akTarget)
{Returns the pet slot REF that is assocated with this actor. Throws if target is not in any pet slot.}
	if (PetREF[0].GetReference() == akTarget)
		return PetREF[0]
	elseIf (PetREF[1].GetReference() == akTarget)
		return PetREF[1]
	elseIf (PetREF[2].GetReference() == akTarget)
		return PetREF[2]
	else
		MessageBox("Error: Target does not belong to any known pet slot")
		return NONE
	endIf
endFunction

ReferenceAlias function GetHungerRefForActor(Actor akTarget)
{Returns the hunger REF that is assocated with this actor. Throws if target is not in any pet slot.}
	if (PetREF[0].GetReference() == akTarget)
		return PetHungerREF[0]
	elseIf (PetREF[1].GetReference() == akTarget)
		return PetHungerREF[1]
	elseIf (PetREF[2].GetReference() == akTarget)
		return PetHungerREF[2]
	else
		MessageBox("Error: Target does not belong to any known pet slot")
		return NONE
	endIf
endFunction

int function GetSlotNumberForActor(Actor akTarget)
{Returns the pet slot number that is assocated with this actor. Throws if target is not in any pet slot.}
	if (PetREF[0].GetReference() == akTarget)
		return 0
	elseIf (PetREF[1].GetReference() == akTarget)
		return 1
	elseIf (PetREF[2].GetReference() == akTarget)
		return 2
	else
		MessageBox("Error: Target does not belong to any known pet slot")
		return -1
	endIf
endFunction

function UpdateHungerAbilities(Actor akTarget)
{Updates the target's hunger abilities based on its current hunger.}
	string hungerAVName = 	((self as Quest) as Mumirnik_Quest_Instincts_PetStats).HungerAVName
	float hunger = akTarget.GetActorValue(hungerAVName)
	if (hunger >= 90)
		akTarget.AddSpell(HungerBuffSpell[0], false)
		akTarget.RemoveSpell(HungerBuffSpell[1])
		akTarget.RemoveSpell(HungerBuffSpell[2])
		akTarget.RemoveSpell(HungerBuffSpell[3])
		akTarget.RemoveSpell(HungerBuffSpell[4])
		akTarget.RemoveSpell(HungerBuffSpell[5])
	elseIf (hunger >= 70)
		akTarget.RemoveSpell(HungerBuffSpell[0])
		akTarget.AddSpell(HungerBuffSpell[1], false)
		akTarget.RemoveSpell(HungerBuffSpell[2])
		akTarget.RemoveSpell(HungerBuffSpell[3])
		akTarget.RemoveSpell(HungerBuffSpell[4])
		akTarget.RemoveSpell(HungerBuffSpell[5])
	elseIf (hunger >= 50)
		akTarget.RemoveSpell(HungerBuffSpell[0])
		akTarget.RemoveSpell(HungerBuffSpell[1])
		akTarget.AddSpell(HungerBuffSpell[2], false)
		akTarget.RemoveSpell(HungerBuffSpell[3])
		akTarget.RemoveSpell(HungerBuffSpell[4])
		akTarget.RemoveSpell(HungerBuffSpell[5])
	elseIf (hunger >= 30)
		akTarget.RemoveSpell(HungerBuffSpell[0])
		akTarget.RemoveSpell(HungerBuffSpell[1])
		akTarget.RemoveSpell(HungerBuffSpell[2])
		akTarget.AddSpell(HungerBuffSpell[3], false)
		akTarget.RemoveSpell(HungerBuffSpell[4])
		akTarget.RemoveSpell(HungerBuffSpell[5])
	elseIf (hunger >= 10)
		akTarget.RemoveSpell(HungerBuffSpell[0])
		akTarget.RemoveSpell(HungerBuffSpell[1])
		akTarget.RemoveSpell(HungerBuffSpell[2])
		akTarget.RemoveSpell(HungerBuffSpell[3])
		akTarget.AddSpell(HungerBuffSpell[4], false)
		akTarget.RemoveSpell(HungerBuffSpell[5])
	else
		akTarget.RemoveSpell(HungerBuffSpell[0])
		akTarget.RemoveSpell(HungerBuffSpell[1])
		akTarget.RemoveSpell(HungerBuffSpell[2])
		akTarget.RemoveSpell(HungerBuffSpell[3])
		akTarget.RemoveSpell(HungerBuffSpell[4])
		akTarget.AddSpell(HungerBuffSpell[5], false)
	endIf
endFunction

function RefreshHungerDisplay(Actor akTarget)
{Refreshes the target's hunger display. Does not update the actual hunger stat.}
	ReferenceAlias ThisPetHungerREF = GetHungerRefForActor(akTarget)

	ObjectReference petHungerInstanceOld = ThisPetHungerREF.GetReference()
	ThisPetHungerREF.ForceRefTo(NONE)
	petHungerInstanceOld.Delete()

	string hungeRAVName = ((self as Quest) as Mumirnik_Quest_Instincts_PetStats).HungerAVName
	int Hunger = akTarget.GetActorValue(hungerAVName) as int
	Activator petHungerType = NONE
	if (Hunger >= 90)
		petHungerType = PetHungerActivator[0]
	elseIf (Hunger >= 70)
		petHungerType = PetHungerActivator[1]
	elseIf (Hunger >= 50)
		petHungerType = PetHungerActivator[2]
	elseIf (Hunger >= 30)
		petHungerType = PetHungerActivator[3]
	elseIf (Hunger >= 10)
		petHungerType = PetHungerActivator[4]
	else
		petHungerType = PetHungerActivator[5]
	endIf
	ObjectReference petHungerInstance = Game.GetPlayer().PlaceAtMe(petHungerType)
	ThisPetHungerREF.ForceRefTo(petHungerInstance)	
endFunction