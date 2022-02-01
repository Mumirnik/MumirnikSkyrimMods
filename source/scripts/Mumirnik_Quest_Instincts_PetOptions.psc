Scriptname Mumirnik_Quest_Instincts_PetOptions extends Quest  
{The guts of the pet system. Handles pet taming and releasing, and manages pet slots and the slot cap.}

import Debug
import Game
import Utility

Activator property PetNameBaseActivator auto
Activator[] property PetHungerActivator auto
{MUST be at least 6 items. Hunger progression is hardcoded.}
Actor property PlayerREF auto
ActorBase property EncWolfIce auto
{Used for special casing.}
ActorBase property EncWolfIcePetF auto
{Used for special casing.}
ActorBase property EncWolfIcePetM auto
{Used for special casing.}
FormList property OriginalRaceList auto
{List of races that can be turned into pets.}
;FormList property PetActorList auto
FormList property PetActorListM auto
{List of pet actors.}
FormList property PetActorListF auto
{List of pet actors.}
FormList property PetPowerValuesList auto
{The power for each pet race/original race.}
FormList property PetNameF auto
FormList property PetNameM auto
FormList property PetNameUnaggressiveF auto
FormList property PetNameUnaggressiveM auto
GlobalVariable property PetCount auto
{Current number of pets.}
GlobalVariable property PetPower auto
{Total amount of power among pets. Used to prevent stacking powerful pets.}
GlobalVariable property PetPowerMax auto
GlobalVariable property SpeechcraftExperienceGainTaming Auto
Keyword property IsUnaggressivePetRaceKeyword auto
Message property ChanceToTame auto
Message property ChanceToTameFAILED auto
Message property PetCountCheckFAILED auto
Message property PetPowerCheckFAILED auto
Message[] property TamedMessage auto
{Shown when a pet is tamed.}
Race[] property ForcedFemaleRaceList auto
{Original races in this list will always become female.}
Race[] property ForcedMaleRaceList auto
{Original races in this list will always become male.}
Race[] property ForcedRandomGenderMaleVisualsRaceList auto
{Original races in this list will become a random gender, but will use male visuals.}
Race[] property ForcedRandomGenderRaceList auto
{Original races in this list will become a random gender and get the appropriate visuals.}
Race property WolfRace auto
{Used for special casing.}
ReferenceAlias[] property PetREF auto
ReferenceAlias[] property PetNameREF auto
ReferenceAlias[] property PetHungerREF auto
Sound property TamedSound auto
Spell[] property HungerBuffSpell auto
{MUST be at least 6 items. Hunger progression is hardcoded.}
String property GenderAVName auto
{M = 1, F = 2}
String property PowerAVName auto
{Set on the pet to help with release and stats.}

bool TimerIsRunning = false
Actor AnimalToTame = NONE
float TameChance = 0.0

bool function CheckPowerBudget(Actor akTarget)
{Returns whether the target can be made into a pet without exceeding the power budget. True if yes, false and error message if no.}
	float playerSkill = PlayerREF.GetActorValue("Speechcraft")
	if (playerSkill < 20)
		PetPowerMax.SetValue(6)
	elseIf (playerSkill < 40)
		PetPowerMax.SetValue(7)
	elseIf (playerSkill < 60)
		PetPowerMax.SetValue(8)
	elseIf (playerSkill < 80)
		PetPowerMax.SetValue(9)
	else
		PetPowerMax.SetValue(10)
	endIf

	Race originalRace = akTarget.GetRace()
	int originalRaceId = GetRaceIdForRace(originalRace)
	int power = GetPowerForRaceId(originalRaceId)

	int currentPetPower = PetPower.GetValue() as int
	int currentPetPowerMax = PetPowerMax.GetValue() as int
	if ((currentPetPower + power) > currentPetPowerMax)
		PetPowerCheckFAILED.Show(currentPetPower, currentPetPowerMax, power)
		return false
	else
		if (petCount.GetValue() == 3)
			PetCountCheckFAILED.Show()
			return false
		else
			return true
		endIf
	endIf
endFunction

function TryMakePet(Actor akTarget, float aiValue)
{This is called from the taming feature. It is a thread safe way to make a target your pet.}
	AnimalToTame = akTarget
	TameChance += aiValue
	ChanceToTame.Show(TameChance)
	RegisterForSingleUpdate(0.02)
endFunction

event OnUpdate()
	if (AnimalToTame)
		if (RandomInt(0, 99) < TameChance)
			MakePet(AnimalToTame)
		else
			ChanceToTameFAILED.Show()
		endIf
		AnimalToTame = NONE
		TameChance = 0.0
	endIf
endEvent

function MakePet(Actor akTarget)
{This makes the target your pet, initializes its stats and starts the hunger timer. Will throw if the target is an invalid race or there are no free pet slots.}
	akTarget.SetAlpha(0.0, true)
	akTarget.SetCriticalStage(akTarget.CritStage_DisintegrateEnd)

	Race originalRace = akTarget.GetRace()
	int originalRaceId = GetRaceIdForRace(originalRace)

	int gender = 0
	if (ForcedFemaleRaceList.Find(originalRace) != -1)
		gender = 2	; because chickens and cows are apparently male in vanilla
	elseIf (ForcedMaleRaceList.Find(originalRace) != -1)
		gender = 1
	elseIf (ForcedRandomGenderRaceList.Find(originalRace) != -1 || ForcedRandomGenderMaleVisualsRaceList.Find(originalRace) != -1)
		gender = RandomInt(1,2)
	else
		gender = akTarget.GetLeveledActorBase().GetSex() + 1
	endIf

	ActorBase newActorBase = NONE
	if (gender == 1 || ForcedRandomGenderMaleVisualsRaceList.Find(originalRace) != -1)
		newActorBase = PetActorListM.GetAt(originalRaceId) as ActorBase
	elseIf (gender == 2)
		newActorBase = PetActorListF.GetAt(originalRaceId) as ActorBase
	else
		MessageBox("Error: Unknown gender")
	endIf

	if (originalRace == WolfRace && akTarget.GetActorBase() == EncWolfIce)
		if (gender == 1 || ForcedRandomGenderMaleVisualsRaceList.Find(originalRace) != -1)
			newActorBase = EncWolfIcePetM ; special case for ice wolves which do not have a custom race but do have higher stats
		elseIf (gender == 2)
			newActorBase = EncWolfIcePetF ; special case for ice wolves which do not have a custom race but do have higher stats
		endIf
	endIf
	
	Actor petActor = akTarget.PlaceActorAtMe(newActorBase)
	PetActor.MoveTo(akTarget)

	TamedSound.Play(petActor)

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
		petActor.Delete()
		return
	endIf

	akTarget.Kill()

	petActor.StopCombat()
	petActor.SetPlayerTeammate(true, false)
	petActor.EvaluatePackage()

	TamedMessage[slotFilled].Show()

	petActor.RestoreActorValue("Health", 10000)
	((self as Quest) as Mumirnik_Quest_Instincts_PetStats).SetHunger(petActor, 50)
	((self as Quest) as Mumirnik_Quest_Instincts_PetTraining).InitTrainingProgression(petActor, originalRaceId)

	SetBaseNameDisplay(petActor, gender)

	PetCount.Mod(1)
	int power = GetPowerForRaceId(originalRaceId)
	PetPower.Mod(power)
	petActor.SetActorValue(PowerAVName, power)

	if (PetPower.GetValue() > PetPowerMax.GetValue())
		MessageBox("Error: Pet power overflow, this should not happen at this point! Releasing new pet")
		ReleasePet(petActor)
		return
	endIf

	;petActor.AllowBleedoutDialogue(true)

	AdvanceSkill("Speechcraft", SpeechcraftExperienceGainTaming.GetValue())

	if (!TimerIsRunning)
		TimerIsRunning = true
		RegisterForSingleUpdateGameTime(1.0)
	endIf
endFunction

function ReleasePet(Actor akTarget)
{This releases your pet and clears the pet slot. Will throw if the pet is an invalid race or does not exist in a pet slot.}
	akTarget.BlockActivation(true)

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

	Race originalRace = akTarget.GetRace()

	PetCount.Mod(-1)
	PetPower.Mod(-akTarget.GetActorValue(PowerAVName))

	akTarget.Disable(true)
	akTarget.Delete()

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
		MessageBox("Error: Cannot find ref for actor because target does not belong to any known pet slot")
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
		MessageBox("Error: Cannot find hunger ref for actor because target does not belong to any known pet slot")
		return NONE
	endIf
endFunction

ReferenceAlias function GetNameRefForActor(Actor akTarget)
{Returns the name REF that is assocated with this actor. Throws if target is not in any pet slot.}
	if (PetREF[0].GetReference() == akTarget)
		return PetNameREF[0]
	elseIf (PetREF[1].GetReference() == akTarget)
		return PetNameREF[1]
	elseIf (PetREF[2].GetReference() == akTarget)
		return PetNameREF[2]
	else
		MessageBox("Error: Cannot find name ref for actor because target does not belong to any known pet slot")
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
		MessageBox("Error: Cannot find slot number for actor because target does not belong to any known pet slot")
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

	string hungerAVName = ((self as Quest) as Mumirnik_Quest_Instincts_PetStats).HungerAVName
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
	ObjectReference petHungerInstance = PlayerREF.PlaceAtMe(petHungerType)
	ThisPetHungerREF.ForceRefTo(petHungerInstance)	
endFunction

function SetBaseNameDisplay(Actor akTarget, int aiGender)
{Sets the target's name to its base name.}
	akTarget.SetActorValue(GenderAVName, aiGender)

	ReferenceAlias ThisPetNameREF = GetNameRefForActor(akTarget)
	ObjectReference petNameInstance = Game.GetPlayer().PlaceAtMe(PetNameBaseActivator)
	ThisPetNameREF.ForceRefTo(petNameInstance)
endFunction

function RerollNameDisplay(Actor akTarget)
{Refreshes the target's name display randomly.}
	ReferenceAlias ThisPetNameREF = GetNameRefForActor(akTarget)

	ObjectReference petNameInstanceOld = ThisPetNameREF.GetReference()
	ThisPetNameREF.ForceRefTo(NONE)
	petNameInstanceOld.Delete()

	Activator petNameType = NONE
	int gender = akTarget.GetActorValue(GenderAVName) as int
	if (!akTarget.HasKeyword(IsUnaggressivePetRaceKeyword))
		if (gender == 1)
			petNameType = PetNameM.GetAt(RandomInt(0, PetNameM.GetSize() - 1)) as Activator
		elseIf (gender == 2)
			petNameType = PetNameF.GetAt(RandomInt(0, PetNameM.GetSize() - 1)) as Activator
		else
			MessageBox("Error: Target has invalid gender")
			return NONE
		endIf
	else
		if (gender == 1)
			petNameType = PetNameUnaggressiveM.GetAt(RandomInt(0, PetNameM.GetSize() - 1)) as Activator
		elseIf (gender == 2)
			petNameType = PetNameUnaggressiveF.GetAt(RandomInt(0, PetNameM.GetSize() - 1)) as Activator
		else
			MessageBox("Error: Target has invalid gender")
			return NONE
		endIf
	endIf
	ObjectReference petNameInstance = Game.GetPlayer().PlaceAtMe(petNameType)
	ThisPetNameREF.ForceRefTo(petNameInstance)	
endFunction

int function GetPowerForRaceId(int aiRaceId)
{Returns the power for a given race ID.}
	return (PetPowerValuesList.GetAt(aiRaceId) as GlobalVariable).GetValue() as int
endFunction

int function GetRaceIdForRace(Race akRace)
{Returns the original race ID for a given actor race.}
	int originalRaceId = -1
	originalRaceId = OriginalRaceList.Find(akRace)
	if (originalRaceId == -1)
		MessageBox("Error: Unknown actor race")
	endIf
	return originalRaceId
endFunction

function TurnToPlayer(Actor akTarget)
{Turns the target to face the player.}
	float zOffset = akTarget.GetHeadingAngle(PlayerREF)
	akTarget.SetAngle(akTarget.GetAngleX(), akTarget.GetAngleY(), akTarget.GetAngleZ() + zOffset)
endFunction