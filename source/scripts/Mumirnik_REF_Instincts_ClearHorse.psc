Scriptname Mumirnik_REF_Instincts_ClearHorse extends ReferenceAlias  
{When this REF is no longer ridden, clear it.}

float property StayMountedUpdateTimer auto

Actor RiderREF

function Ride(Actor akRider)
	RiderREF = akRider
	RegisterForSingleUpdate(StayMountedUpdateTimer)
endFunction

event OnUpdate()	; this handles dismounting by accident (falling off)
	if (!RiderREF.IsOnMount())
		StopRiding()
	else
		RegisterForSingleUpdate(StayMountedUpdateTimer)
	endIf
endEvent

event OnActivate(ObjectReference akActivator)	; this handles intentional dismounting
	if (akActivator == RiderREF)
		RiderREF.Dismount()
	endIf
endEvent

function StopRiding()
	self.GetReference().BlockActivation(false)
	self.Clear()
endFunction