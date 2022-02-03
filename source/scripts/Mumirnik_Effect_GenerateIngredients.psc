Scriptname Mumirnik_Effect_GenerateIngredients extends activemagiceffect  

float property UpdateTimerGameTime auto
Ingredient property IngredientToGenerate auto
int property MaxIngredients auto

event OnEffectStart(Actor akTarget, Actor akCaster)
	RegisterForSingleUpdateGameTime(UpdateTimerGameTime)
endEvent

event OnUpdateGameTime()
	Actor targetActor = GetTargetActor()
	if (targetActor.GetItemCount(IngredientToGenerate) < MaxIngredients)
		targetActor.AddItem(IngredientToGenerate)
	endIf
	RegisterForSingleUpdateGameTime(UpdateTimerGameTime)
endEvent