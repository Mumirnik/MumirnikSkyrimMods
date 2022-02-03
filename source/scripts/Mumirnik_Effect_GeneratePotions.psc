Scriptname Mumirnik_Effect_GeneratePotions extends activemagiceffect  

float property UpdateTimerGameTime auto
Potion property PotionToGenerate auto
int property MaxPotions auto

event OnEffectStart(Actor akTarget, Actor akCaster)
	RegisterForSingleUpdateGameTime(UpdateTimerGameTime)
endEvent

event OnUpdateGameTime()
	Actor targetActor = GetTargetActor()
	if (targetActor.GetItemCount(PotionToGenerate) < MaxPotions)
		targetActor.AddItem(PotionToGenerate)
	endIf
	RegisterForSingleUpdateGameTime(UpdateTimerGameTime)
endEvent