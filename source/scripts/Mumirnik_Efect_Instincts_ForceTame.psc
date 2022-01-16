Scriptname Mumirnik_Efect_Instincts_ForceTame extends activemagiceffect 
{When this magic effect is applied to a target, tames the target.}

Quest property PetOptionsQuest  auto

event OnEffectStart(Actor akTarget, Actor akCaster)

	(PetOptionsQuest as Mumirnik_Quest_Instincts_PetOptions).MakePet(akTarget)

endEvent