Scriptname Mumirnik_Activator_Sawtooth_Hazard extends ObjectReference  

import Math
import Utility

Actor property PlayerREF auto
Ammo property HitFXAmmo auto
bool property MustBeMoving auto
int property SoundLevel = 10 auto 
Sound property TrapHitSound auto
Spell property TrapSpell auto
Weapon property HitFX auto


event OnTrigger(ObjectReference akActionRef)
	if (akActionRef as Actor)
		Actor targetActor = akActionRef as Actor
		if (!targetActor.IsDead() && !targetActor.IsGhost())
			if (!MustBeMoving || targetActor.IsRunning() || targetActor.IsSprinting())
				DoLocalHit(targetActor)
			endIf
		endIf
	endIf
endEvent

function DoLocalHit(Actor akTarget)
	TrapSpell.RemoteCast(self, PlayerREF, akTarget)
	TrapHitSound.Play(self)
	HitFX.Fire(self, hitFxAmmo)
	CreateDetectionEvent(akTarget, SoundLevel)
endFunction

