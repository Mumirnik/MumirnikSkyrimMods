Scriptname Mumirnik_Quest_Instincts_PetStats extends Quest  
{Manages all pet stats. Exposes functions to modify innate pet stats, modify stats, and display stats.}

GlobalVariable property HungerDecayRateGlobal auto
GlobalVariable property HungerDecayRateWhenWaitingGlobal auto
GlobalVariable property PetCount auto
Keyword property IsUnaggressivePetRace auto
Message[] property HungerLimitMaxMessage auto
Message[] property HungerLimitMinMessage auto
Message[] property HungerChangeMessage auto
Message[] property PetStatisticsMessage auto
string property HungerAVName auto
{The name of the actor value that tracks Hunger.}
string property HungerFortifyAVName auto
{The name of the actor value for Fortify Hunger effects.}
string property ExperienceFortifyAVName auto
{The name of the actor value for Fortify Experience effects.}

bool StarvationWarningTriggered = false

function ShowPetStats(Actor akTarget, int aiSlot = -1)
{Shows a message box with the pet's current stats and level.}
	if (aiSlot == -1)
		aiSlot = ((self as Quest) as Mumirnik_Quest_Instincts_PetOptions).GetSlotNumberForActor(akTarget)
	endIf
	string petLevelAVName = ((self as Quest) as Mumirnik_Quest_Instincts_PetTraining).PetLevelAVName
	string petLevelProgressAVName = ((self as Quest) as Mumirnik_Quest_Instincts_PetTraining).PetLevelProgressAVName
	float petLevel = akTarget.GetActorValue(petLevelAVName)
	float petLevelProgress = akTarget.GetActorValue(petLevelProgressAVName)
	float petDamage = akTarget.GetActorValue("UnarmedDamage")
	float petCarryWeight = 0
	if (akTarget.HasKeyword(IsUnaggressivePetRace))
		petCarryWeight = akTarget.GetActorValue("CarryWeight")
	endIf
	float petHealthMax = akTarget.GetActorValue("Health")
	float petHungerModifier = akTarget.GetActorValue(HungerFortifyAVName)
	float petExperienceModifier = akTarget.GetActorValue(ExperienceFortifyAVName)
	PetStatisticsMessage[aiSlot].Show(petLevel, (petLevelProgress as int), (petLevelProgress - (petLevelProgress as int)) * 100, petDamage, petCarryWeight, petHealthMax, petHungerModifier, petExperienceModifier)
endFunction

function UpdatePetStatsGameTime(Actor akTarget)
{Ticks every hour on each pet. Handles hunger decay and experience growth.}
	bool isWaiting = (akTarget.GetActorValue("WaitingForPlayer") == 1)
	float hungerDecay = 0
	if (isWaiting)
		hungerDecay = HungerDecayRateWhenWaitingGlobal.GetValue()
	else
		hungerDecay = HungerDecayRateGlobal.GetValue()
	endIf
	hungerDecay *= ((100 - akTarget.GetActorValue(HungerFortifyAVName)) / 100)
	ModHunger(akTarget, -hungerDecay)

	string petLevelAVName = ((self as Quest) as Mumirnik_Quest_Instincts_PetTraining).PetLevelAVName
	int petLevel = akTarget.GetActorValue(petLevelAVName) as int
	float progressAmount = 1.0 / (petLevel + 1.0)
	((self as Quest) as Mumirnik_Quest_Instincts_PetTraining).Progress(akTarget, progressAmount)
endFunction

function SetHunger(Actor akTarget, float aiValue)
{Updates the hunger stat and refreshes the visual display. Call this to change hunger.}
	akTarget.SetActorValue(HungerAVName, aiValue)

	((self as Quest) as Mumirnik_Quest_Instincts_PetOptions).UpdateHungerAbilities(akTarget)
	((self as Quest) as Mumirnik_Quest_Instincts_PetOptions).RefreshHungerDisplay(akTarget)
endFunction

function ModHunger(Actor akTarget, float aiValue)
{Updates the hunger stat and refreshes the visual display. Call this to change hunger.}
	akTarget.ModActorValue(HungerAVName, aiValue)

	float value = akTarget.GetActorValue(HungerAVName)
	if (value < 0)
		akTarget.ModActorValue(HungerAVName, -value)
		if (akTarget.GetActorValue("WaitingForPlayer") == 1 && !StarvationWarningTriggered)
			int slotNumber = ((self as Quest) as Mumirnik_Quest_Instincts_PetOptions).GetSlotNumberForActor(akTarget)
			HungerLimitMinMessage[slotNumber].Show()
			StarvationWarningTriggered = true
		endIf
	else
		StarvationWarningTriggered = false
		if (value > 100)
			akTarget.ModActorValue(HungerAVName, 100 - value)
			int slotNumber = ((self as Quest) as Mumirnik_Quest_Instincts_PetOptions).GetSlotNumberForActor(akTarget)
			HungerLimitMaxMessage[slotNumber].Show()
		endIf
	endIf

	((self as Quest) as Mumirnik_Quest_Instincts_PetOptions).UpdateHungerAbilities(akTarget)
	((self as Quest) as Mumirnik_Quest_Instincts_PetOptions).RefreshHungerDisplay(akTarget)
endFunction