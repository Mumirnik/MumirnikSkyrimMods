Scriptname Mumirnik_Effect_ModAVTemporary extends activemagiceffect  
{Modifies an actor value for the duration of this magic effect.}

float property Amount auto
string property Value auto

float RealAmount

event OnEffectStart(Actor akTarget, Actor akCaster)

	akTarget.ModActorValue(Value, RealAmount)

endEvent

event OnEffectFinish(Actor akTarget, Actor akCaster)

	akTarget.ModActorValue(Value, -RealAmount)

endEvent
