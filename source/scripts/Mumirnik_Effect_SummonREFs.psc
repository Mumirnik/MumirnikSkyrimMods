Scriptname Mumirnik_Effect_SummonREFs extends activemagiceffect  

float property SummonEffectDuration auto
ReferenceAlias[] property ActorREFs auto
VisualEffect property SummonEffect auto

event OnEffectStart(Actor akTarget, Actor akCaster)
	int i = 0
	while (i < ActorREFs.Length - 1)
		Actor actorToTeleport = ActorREFs[i].GetReference() as Actor
		if (actorToTeleport)
			actorToTeleport.MoveTo(akTarget)
			actorToTeleport.SetActorValue("WaitingForPlayer", 0)
			SummonEffect.Play(actorToTeleport, SummonEffectDuration)
		endIf
		i += 1
	endWhile
endEvent