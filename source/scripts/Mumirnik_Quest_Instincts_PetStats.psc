Scriptname Mumirnik_Quest_Instincts_PetStats extends Quest  
{Manages all pet stats. Exposes functions to modify innate pet stats, modify stats, and display stats.}

float property PetHealthPercentMod auto
{The delta applied to health to determine a newly tamed pet's stats.}
GlobalVariable property HungerDecayRateGlobal auto
GlobalVariable property HungerDecayRateWhenWaitingGlobal auto
GlobalVariable property PetCount auto
Message[] property HungerLimitMaxMessage auto
Message[] property HungerLimitMinMessage auto
Message[] property HungerChangeMessage auto
Message[] property PetStatisticsMessage auto
string property HealthInnateModifierAVName auto
{The name of the actor value that keeps track of how much the pet's health has been globally modified by upon taming. This is necessary because there's no health percentage modifier so we need to calculate the flat equivalent and store it.}
string property HungerAVName auto
{The name of the actor value that tracks Hunger.}
string property HungerFortifyAVName auto
{The name of the actor value for Fortify Hunger effects.}
string property ExperienceFortifyAVName auto
{The name of the actor value for Fortify Experience effects.}

bool StarvationWarningTriggered = false

function ShowPetStats(Actor akTarget, int aiSlot)
{Shows a message box with the pet's current stats and level.}
	string petLevelAVName = ((self as Quest) as Mumirnik_Quest_Instincts_PetTraining).PetLevelAVName
	float petLevel = akTarget.GetActorValue(petLevelAVName)
	float petDamage = akTarget.GetActorValue("UnarmedDamage")
	float petHealthMax = akTarget.GetActorValue("Health")
	float petHungerModifier = akTarget.GetActorValue(HungerFortifyAVName)
	PetStatisticsMessage[aiSlot].Show(petLevel, petDamage, petHealthMax, petHungerModifier)
endFunction

;function ApplyPetStatMultipliers(Actor akTarget)
;{Modifies the innate pet stats of a newly tamed pet. Pets have their health globally modified to make them balanced.}
;	float calculatedHealthMod = akTarget.GetActorValue("Health") * PetHealthPercentMod * (-1)
;	akTarget.ModActorValue("Health", calculatedHealthMod)
;	akTarget.ModActorValue(HealthInnateModifierAVName, calculatedHealthMod)
;endFunction

;function RevertPetStatMultipliers(Actor akTarget)
;{Reverts the innate pet stats of a newly tamed pet. Pets have their health globally modified to make them balanced.}
;	float calculatedHealthMod = akTarget.GetActorValue(HealthInnateModifierAVName)
;	akTarget.ModActorValue("Health", -calculatedHealthMod)
;	akTarget.ModActorValue(HealthInnateModifierAVName, -calculatedHealthMod)
;endFunction

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
	((self as Quest) as Mumirnik_Quest_Instincts_PetTraining).Progress(akTarget, 1.0)
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
		akTarget.SetActorValue(HungerAVName, 0)
		if (akTarget.GetActorValue("WaitingForPlayer") == 1 && !StarvationWarningTriggered)
			int slotNumber = ((self as Quest) as Mumirnik_Quest_Instincts_PetOptions).GetSlotNumberForActor(akTarget)
			HungerLimitMinMessage[slotNumber].Show()
			StarvationWarningTriggered = true
		endIf
	else
		StarvationWarningTriggered = false
		If (value > 100)
			akTarget.SetActorValue(HungerAVName, 100)
			int slotNumber = ((self as Quest) as Mumirnik_Quest_Instincts_PetOptions).GetSlotNumberForActor(akTarget)
			HungerLimitMaxMessage[slotNumber].Show()
		endIf
	endIf

	((self as Quest) as Mumirnik_Quest_Instincts_PetOptions).UpdateHungerAbilities(akTarget)
	((self as Quest) as Mumirnik_Quest_Instincts_PetOptions).RefreshHungerDisplay(akTarget)
endFunction