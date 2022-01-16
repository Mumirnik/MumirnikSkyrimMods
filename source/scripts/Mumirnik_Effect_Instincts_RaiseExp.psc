Scriptname Mumirnik_Effect_Instincts_RaiseExp extends activemagiceffect  

GlobalVariable property ExperienceAmount auto
Quest property PetOptionsQuest auto

event OnEffectStart(Actor akTarget, Actor akCaster)

	(PetOptionsQuest as Mumirnik_Quest_Instincts_PetTraining).Progress(akCaster, ExperienceAmount.GetValue())

endEvent
