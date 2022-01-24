Scriptname Mumirnik_Quest_Instincts_PetTraining extends Quest  
{Handles pet training and progression. Exposes functions to initialize progression, train the pet, and undo all progression.}

import Debug
import Game

Actor property PlayerREF auto
FormList property PetLevelsList auto
{The level for each pet race/original race.}
GlobalVariable property SpeechcraftExperienceGainTraining auto
GlobalVariable property TrainingIncrementAttackDamageGlobal auto
GlobalVariable property TrainingIncrementHealthGlobal auto
GlobalVariable property TrainingIncrementHungerFortifyGlobal auto
GlobalVariable property TrainingIncrementCarryWeightGlobal auto
Keyword property IsUnaggressivePetRace auto
Message property LevelUpMessage auto
Message[] property PetStatisticsTrainingMessage auto
Message[] property PetStatisticsTrainingMessageUnaggressive auto
Message[] property ProgressionAvailableMessage auto
Message property TrainingConfirmMessageAttackDamage auto
Message property TrainingConfirmMessageHealth auto
Message property TrainingConfirmMessageHungerFortify auto
Message property TrainingConfirmMessageCarryWeight auto
string property PetLevelAVName auto
{The name of the actor value that tracks the "level" the target pet is currently at at. This does not correspond to their real level for technical reasons. It caps out at PetLevelProgressAVName.}
string property PetLevelProgressAVName auto
{The name of the actor value that tracks the "level" progression of the target pet. This creeps up as you do things that increase its "level". The maximum amount of "levels" the pet can get is equal to Floor(this).}
string property PetLevelAvailableFlagAVName auto
{The name of the actor value that flags the target pet as being able to level up.}

function InitTrainingProgression(Actor akTarget, int aiRaceId)
{Initializes training progression when the animal is tamed.}
	int level = (PetLevelsList.GetAt(aiRaceId) as GlobalVariable).GetValue() as int
	akTarget.SetActorValue(PetLevelAVName, level)
	akTarget.SetActorValue(PetLevelProgressAVName, level)
	akTarget.SetActorValue(PetLevelAvailableFlagAVName, 0.0)
endFunction

function Train(Actor akTarget)
{Shows the training dialog for a pet and handles the player's selections and resulting progression.}
	int slotNumber = ((self as Quest) as Mumirnik_Quest_Instincts_PetOptions).GetSlotNumberForActor(akTarget)
	if (slotNumber != -1)
		string hungerFortifyAVName = ((self as Quest) as Mumirnik_Quest_Instincts_PetStats).HungerFortifyAVName
		int petLevelTotal = akTarget.GetActorValue(PetLevelAVName) as int
		float petDamageTotal = akTarget.GetActorValue("UnarmedDamage")
		float petHealthTotal = akTarget.GetActorValue("Health")
		float petHungerFortifyTotal = akTarget.GetActorValue(hungerFortifyAVName)
		float petCarryWeightTotal = akTarget.GetActorValue("CarryWeight")
		int petLevelAdd = 0
		float petDamageAdd = 0
		float petHealthAdd = 0
		float petHungerFortifyAdd = 0
		float petCarryWeightAdd = 0

		float petLevelProgress =  akTarget.GetActorValue(PetLevelProgressAVName)

		float trainingIncrementAttackDamage = TrainingIncrementAttackDamageGlobal.GetValue()
		float trainingIncrementHealth = TrainingIncrementHealthGlobal.GetValue()
		float trainingIncrementHungerFortify = TrainingIncrementHungerFortifyGlobal.GetValue()
		float trainingIncrementCarryWeight = TrainingIncrementCarryWeightGlobal.GetValue()

		bool isUnaggressive = akTarget.HasKeyword(IsUnaggressivePetRace)

		int trainingOption = -1
		while (trainingOption < 3 && petLevelTotal <= ((petLevelProgress as int) - 1))
			if (!isUnaggressive)
				trainingOption = PetStatisticsTrainingMessage[slotNumber].Show(petLevelTotal, petDamageTotal, PetHealthTotal, PetHungerFortifyTotal)
			else
				trainingOption = PetStatisticsTrainingMessageUnaggressive[slotNumber].Show(petLevelTotal, petCarryWeightTotal, PetHealthTotal, PetHungerFortifyTotal)
			endIf
			if (trainingOption == 0)
				if (!isUnaggressive)
					if (TrainingConfirmMessageAttackDamage.Show(petLevelTotal, petLevelTotal + 1, petDamageTotal, petDamageTotal + trainingIncrementAttackDamage) == 0)
						petDamageTotal += trainingIncrementAttackDamage
						petDamageAdd += trainingIncrementAttackDamage
						petLevelTotal += 1
						petLevelAdd += 1
						LevelUpMessage.Show(petLevelTotal)
					endIf
				else
					if (TrainingConfirmMessageCarryWeight.Show(petLevelTotal, petLevelTotal + 1, petCarryWeightTotal, petCarryWeightTotal + trainingIncrementCarryWeight) == 0)
						petCarryWeightTotal += trainingIncrementCarryWeight
						petCarryWeightAdd += trainingIncrementCarryWeight
						petLevelTotal += 1
						petLevelAdd += 1
						LevelUpMessage.Show(petLevelTotal)
					endIf
				endIf
			elseIf (trainingOption == 1)
				if (TrainingConfirmMessageHealth.Show(petLevelTotal, petLevelTotal + 1, petHealthTotal, petHealthTotal + trainingIncrementHealth) == 0)
					petHealthTotal += trainingIncrementHealth
					petHealthAdd += trainingIncrementHealth
					petLevelTotal += 1
					petLevelAdd += 1
					LevelUpMessage.Show(petLevelTotal)
				endIf
			elseIf (trainingOption == 2)
				if (TrainingConfirmMessageHungerFortify.Show(petLevelTotal, petLevelTotal + 1, petHungerFortifyTotal, petHungerFortifyTotal + trainingIncrementHungerFortify) == 0)
					petHungerFortifyTotal += trainingIncrementHungerFortify
					petHungerFortifyAdd += trainingIncrementHungerFortify
					petLevelTotal += 1
					petLevelAdd += 1
					LevelUpMessage.Show(petLevelTotal)
				endIf
			endIf
		endWhile

		if (petLevelAdd > 0)
			akTarget.ModActorValue(PetLevelAVName, petLevelAdd)
			AdvanceSkill("Speechcraft", SpeechcraftExperienceGainTraining.GetValue() * petLevelAdd)
		endIf
		if (petDamageAdd > 0)
			akTarget.ModActorValue("UnarmedDamage", petDamageAdd)
		endIf
		if (petHealthAdd > 0)
			akTarget.ModActorValue("Health", petHealthAdd)
		endIf
		if (petHungerFortifyAdd > 0)
			akTarget.ModActorValue(hungerFortifyAVName, petHungerFortifyAdd)
		endIf
		if (petCarryWeightAdd > 0)
			akTarget.ModActorValue("CarryWeight", petCarryWeightAdd)
		endIf

		if (petLevelTotal < (petLevelProgress as int))
			akTarget.SetActorValue(PetLevelAvailableFlagAVName, 1.0)
		else
			akTarget.SetActorValue(PetLevelAvailableFlagAVName, 0.0)
		endIf

Debug.MessageBox("After training: Level " + akTarget.GetActorValue(PetLevelAVName) + ", available: " + akTarget.GetActorValue(PetLevelAvailableFlagAVName) + ", progression: " + akTarget.GetActorValue(PetLevelProgressAVName))

;		((self as Quest) as Mumirnik_Quest_Instincts_PetStats).ShowPetStats(akTarget, slotNumber)
	endIf
endFunction

function Progress(Actor akTarget, float afValue)
{Gain training progression by advancing PetLevelProgress. This increases the maximum value up to where you can train the pet. Also displays a message. Throws if progress value is negative.} 
	if (afValue <= 0)
		MessageBox("Error: Progress must be positive, received " + afValue)
		return
	endIf

	float petLevel = akTarget.GetActorValue(PetLevelAVName)
	float playerLevel = PlayerREF.GetLevel()
	if (petLevel >= playerLevel)
		return
	endIf

	string experienceFortifyAVName = ((self as Quest) as Mumirnik_Quest_Instincts_PetStats).ExperienceFortifyAVName
	float value = afValue * (100 + akTarget.GetActorValue(experienceFortifyAVName)) / 100

	float oldPetLevelProgress = akTarget.GetActorValue(PetLevelProgressAVName)
	if (value > playerLevel - oldPetLevelProgress)
		value = playerLevel - oldPetLevelProgress
	endIf

	float newPetLevelProgress = oldPetLevelProgress + value
debug.messagebox("old " + oldPetLevelProgress + " new " + newPetLevelProgress + " value " + value)
	if ((oldPetLevelProgress as int) < (newPetLevelProgress as int))
		int slotNumber = ((self as Quest) as Mumirnik_Quest_Instincts_PetOptions).GetSlotNumberForActor(akTarget)
		if (slotNumber != -1)
			ProgressionAvailableMessage[slotNumber].Show(newPetLevelProgress)
		endIf
	endIf

	akTarget.ModActorValue(PetLevelProgressAVName, value)

	if ((petLevel as int) < (newPetLevelProgress as int))
		akTarget.SetActorValue(PetLevelAvailableFlagAVName, 1.0)
	else
		akTarget.SetActorValue(PetLevelAvailableFlagAVName, 0.0)
	endIf

endFunction