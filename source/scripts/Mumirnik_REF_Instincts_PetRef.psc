Scriptname Mumirnik_REF_Instincts_PetRef extends ReferenceAlias  
{Handles this reference receiving food and bleedout.}

GlobalVariable property CurrentPetIsEatingGlobal auto
Message property BleedoutMessage auto
Message property BleedoutMessageHELP auto
Message property DeathMessage auto

event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	if (((akBaseItem as Ingredient) || (akBaseItem as Potion)) && CurrentPetIsEatingGlobal.GetValue() == 1)
		(GetOwningQuest() as Mumirnik_Quest_Instincts_Feeding).ReceiveFood(self.GetActorReference(), akBaseItem, aiItemCount)
	endIf
endEvent

event OnEnterBleedout()
	BleedoutMessage.Show()
	BleedoutMessageHELP.ShowAsHelpMessage("PetBleedout", 8.0, 1.0, 1)
endEvent

event OnDying(Actor akKiller)
	DeathMessage.Show()
	(GetOwningQuest() as Mumirnik_Quest_Instincts_PetOptions).ReleasePet(self.GetActorReference())
endEvent