;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__05014C6D Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
if (ReleaseMessageCONFIRM.Show() == 0)
;	HeartbreakSpell.Cast(PlayerREF, akSpeaker)
	(GetOwningQuest() as Mumirnik_Quest_Instincts_PetOptions).ReleasePet(akSpeaker)
endIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SPELL Property HeartbreakSpell  Auto  

Message Property ReleaseMessageCONFIRM  Auto  

Actor Property PlayerRef  Auto  
