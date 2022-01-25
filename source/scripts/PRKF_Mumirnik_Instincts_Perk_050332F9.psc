;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 22
Scriptname PRKF_Mumirnik_Instincts_Perk_050332F9 Extends Perk Hidden

;BEGIN FRAGMENT Fragment_19
Function Fragment_19(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
;ChanceToTameMessageHELP.ShowAsHelpMessage("ChanceToTame", 8.0, 1.0, 1)
Actor thisActor = akTargetRef as Actor
bool meetsPowerBudget = (PetOptionsQuest as Mumirnik_Quest_Instincts_PetOptions).CheckPowerBudget(thisActor)
if (meetsPowerBudget)
	Utility.Wait(0.02)
	FormList foodListForRace = (PetOptionsQuest as Mumirnik_Quest_Instincts_Feeding).GetFoodListForOriginalRace(thisActor)
	if (foodListForRace)
		TemporaryREF.ForceRefTo(thisActor)
		thisActor.AddInventoryEventFilter(foodListForRace)
		thisActor.ShowGiftMenu(true, foodListForRace, true, false)
		Utility.Wait(0.01)
		TemporaryREF.Clear()
	endIf
endIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
;ChanceToTameMessageHELP.ShowAsHelpMessage("ChanceToTame", 8.0, 1.0, 1)
Actor thisActor = akTargetRef as Actor
bool meetsPowerBudget = (PetOptionsQuest as Mumirnik_Quest_Instincts_PetOptions).CheckPowerBudget(thisActor)
if (meetsPowerBudget)
	Utility.Wait(0.02)
	FormList foodListForRace = (PetOptionsQuest as Mumirnik_Quest_Instincts_Feeding).GetFoodListForOriginalRace(thisActor)
	if (foodListForRace)
		TemporaryREF.ForceRefTo(thisActor)
		thisActor.AddInventoryEventFilter(foodListForRace)
		thisActor.ShowGiftMenu(true, foodListForRace, true, false)
		Utility.Wait(0.01)
		TemporaryREF.Clear()
	endIf
endIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property PetOptionsQuest  Auto  

ReferenceAlias Property TemporaryREF  Auto  

Message Property ChanceToTameMessageHELP  Auto  
