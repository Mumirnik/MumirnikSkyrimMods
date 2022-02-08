Scriptname Mumirnik_Quest_Instincts_PetStats extends Quest  
{Manages all pet stats. Exposes functions to modify innate pet stats, modify stats, and display stats.}

GlobalVariable property HungerDecayRateGlobal auto
GlobalVariable property HungerDecayRateWhenWaitingGlobal auto
GlobalVariable property PetCount auto
Keyword property IsUnaggressivePetRace auto
Message[] property HungerLimitMaxMessage auto
Message[] property HungerLimitMinMessage auto
Message[] property HungerChangeMessage auto
Message[] property PetStatisticsMessageF auto
Message[] property PetStatisticsMessageM auto
string property HungerAVName auto
{The name of the actor value that tracks Hunger.}
string property HungerFortifyAVName auto
{The name of the actor value for Fortify Hunger effects.}
string property MountedSpeedAVName auto
{The name of the actor value for Mounted Speed effects.}
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
	string petGenderAVName = ((self as Quest) as Mumirnik_Quest_Instincts_PetOptions).GenderAVName
	string petPowerAVName = ((self as Quest) as Mumirnik_Quest_Instincts_PetOptions).PowerAVName
	float petLevel = akTarget.GetActorValue(petLevelAVName)
	float petLevelProgress = akTarget.GetActorValue(petLevelProgressAVName)
	float petDamage = akTarget.GetActorValue("UnarmedDamage")
	float petCarryWeight = akTarget.GetActorValue("CarryWeight")
	float petHealthMax = akTarget.GetActorValue("Health")
	float petHungerModifier = akTarget.GetActorValue(HungerFortifyAVName)
	float petExperienceModifier = akTarget.GetActorValue(ExperienceFortifyAVName)
	float petPower = akTarget.GetActorValue(petPowerAVName)
	if (akTarget.GetActorValue(petGenderAVName) == 2)
		PetStatisticsMessageF[aiSlot].Show(petLevel, (petLevelProgress as int), (petLevelProgress - (petLevelProgress as int)) * 100, petDamage, petCarryWeight, petHealthMax, petHungerModifier, petExperienceModifier, petPower)
	else
		PetStatisticsMessageM[aiSlot].Show(petLevel, (petLevelProgress as int), (petLevelProgress - (petLevelProgress as int)) * 100, petDamage, petCarryWeight, petHealthMax, petHungerModifier, petExperienceModifier, petPower)
	endIf
endFunction

function UpdatePetStatsGameTime(Actor akTarget)
{Ticks every hour on each pet. Handles hunger decay and experience growth.}
	bool isWaiting = (akTarget.GetActorValue("WaitingForPlayer") > 0.0)
	float hungerDecay = 0.0
	if (isWaiting)
		hungerDecay = HungerDecayRateWhenWaitingGlobal.GetValue()
	else
		hungerDecay = HungerDecayRateGlobal.GetValue()
	endIf
	hungerDecay *= ((100.0 - akTarget.GetActorValue(HungerFortifyAVName)) / 100.0)
	if (hungerDecay < 0)
		hungerDecay = 0
	endIf
	ModHunger(akTarget, -hungerDecay)

	string petLevelAVName = ((self as Quest) as Mumirnik_Quest_Instincts_PetTraining).PetLevelAVName
	int petLevel = akTarget.GetActorValue(petLevelAVName) as int
	float progressAmount = 1.0 / (petLevel + 1.0)
;	float hunger = akTarget.GetActorValue(HungerAVName)
;	if (hunger > 0)
;		progressAmount = (progressAmount * hunger) / 100.0
;	else
;		progressAmount = 0
;	endIf
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
		if (akTarget.GetActorValue("WaitingForPlayer") > 0 && !StarvationWarningTriggered)
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