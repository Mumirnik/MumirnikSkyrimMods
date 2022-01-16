;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__05014C71 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
int sitStatus = (GetOwningQuest() as Mumirnik_Quest_UseFurniture).UseFurniture(TrainFurniture)
if (sitStatus >= 0)
	(GetOwningQuest() as Mumirnik_Quest_Instincts_PetTraining).Train(akSpeaker)
endIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Furniture Property TrainFurniture  Auto  
