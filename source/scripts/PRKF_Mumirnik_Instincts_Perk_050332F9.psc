;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 6
Scriptname PRKF_Mumirnik_Instincts_Perk_050332F9 Extends Perk Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
Actor thisActor = akTargetRef as Actor
FormList foodListForRace = (PetOptionsQuest as Mumirnik_Quest_Instincts_Feeding).GetFoodListForOriginalRace(thisActor)
if (foodListForRace)
	TemporaryREF.ForceRefTo(thisActor)
	thisActor.AddInventoryEventFilter(foodListForRace)
	thisActor.ShowGiftMenu(true, foodListForRace, true, false)
	Utility.Wait(0.01)
	TemporaryREF.Clear()
endIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property PetOptionsQuest  Auto  

ReferenceAlias Property TemporaryREF  Auto  
