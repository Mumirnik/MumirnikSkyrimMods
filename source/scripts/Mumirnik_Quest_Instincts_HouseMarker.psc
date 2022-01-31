Scriptname Mumirnik_Quest_Instincts_HouseMarker extends Quest  

import Utility

Activator property EmptyActivator auto
Actor property PlayerREF auto
float property WaitDuration auto
ReferenceAlias property HouseMarkerREF auto

function MarkLocation(Actor akTarget)
{Mark the location and send all housed pets to that location.}
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
		Actor pet = petREF[i].GetReference() as Actor
		if (pet.GetActorValue("WaitingForPlayer") == 2)
			pet.EvaluatePackage()
			pet.MoveToPackageLocation()
		endIf
		i += 1
	endWhile
endFunction

function SendToMarkedLocation(Actor akTarget)
{Send the target to the marked location.}
	akTarget.SetActorValue("WaitingForPlayer", 2)
	akTarget.EvaluatePackage()
	akTarget.MoveToPackageLocation()
endFunction