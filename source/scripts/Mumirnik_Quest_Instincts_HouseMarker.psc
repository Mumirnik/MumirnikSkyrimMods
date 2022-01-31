Scriptname Mumirnik_Quest_Instincts_HouseMarker extends Quest  

import Utility

Activator property EmptyActivator auto
Actor property PlayerREF auto
float property WaitDuration auto
ReferenceAlias property HouseMarkerREF auto

function MarkLocation(Actor akTarget)
{Mark the spot as a house, flag the target as housed and send ALL housed pets to the house location.}
	ObjectReference houseMarker = HouseMarkerRef.GetReference()
	if (houseMarker)
		houseMarker.MoveTo(akTarget)
	else
		houseMarker = akTarget.PlaceAtMe(EmptyActivator)
		houseMarkerREF.ForceRefTo(houseMarker)
	endIf
	akTarget.SetActorValue("WaitingForPlayer", 2)
	ReferenceAlias[] petREF = ((self as Quest) as Mumirnik_Quest_Instincts_PetOptions).PetREF
	int i = 0
	while (i < petREF.Length)
		(petREF[i] as Mumirnik_REF_Instincts_PetRef).SendToMarkedLocation()	; we need to send all pets to the new home otherwise they will walk there by themselves and go AWOL in the meantime
		i += 1
	endWhile
endFunction

function SendToMarkedLocation(Actor akTarget)
{Flag the target as housed and send it to the house location.}
	akTarget.SetActorValue("WaitingForPlayer", 2)
	ReferenceAlias targetREF = ((self as Quest) as Mumirnik_Quest_Instincts_PetOptions).GetRefForActor(akTarget)
	(targetREF as Mumirnik_REF_Instincts_PetRef).SendToMarkedLocation()
endFunction