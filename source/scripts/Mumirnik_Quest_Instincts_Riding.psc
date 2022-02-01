Scriptname Mumirnik_Quest_Instincts_Riding extends Quest  
{Allows riding a tamed animal.}

Actor property PlayerREF auto
ReferenceAlias property MountREF auto

function Ride(Actor akTarget)
{Makes the player ride the target.}
	if (akTarget.GetActorValue("WaitingForPlayer") == 2)
		akTarget.SetActorValue("WaitingForPlayer", 1)
	endIf
	MountREF.ForceRefTo(akTarget)
	RegisterForSingleUpdate(0.02)	; give dialogue time to close
endFunction

event OnUpdate()
	Actor targetREF = MountREF.GetReference() as Actor
	targetREF.Activate(PlayerREF, true)
	targetREF.BlockActivation(true)
	(MountREF as Mumirnik_REF_Instincts_ClearHorse).Ride(PlayerREF)
endEvent