Scriptname Mumirnik_Effect_Instincts_ModHunger extends activemagiceffect  
{Modifies hunger when applied to a target.}

GlobalVariable property HungerAmount auto
Quest property PetOptionsQuest auto

event OnEffectStart(Actor akTarget, Actor akCaster)

	(PetOptionsQuest as Mumirnik_Quest_Instincts_PetStats).ModHunger(akCaster, HungerAmount.GetValue())

endEvent
