;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__05060D21 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
if (Game.GetPlayer().IsWeaponDrawn())
	MountedWeaponsMessageFAILED.Show()
else
	(akSpeaker as Actor).SetDoingFavor(false)
	(GetOwningQuest() as Mumirnik_Quest_Instincts_Riding).Ride(akSpeaker)
endIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Message Property MountedWeaponsMessageFAILED  Auto  
