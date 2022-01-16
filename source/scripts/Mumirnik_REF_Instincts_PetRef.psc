Scriptname Mumirnik_REF_Instincts_PetRef extends ReferenceAlias  
{Handles this reference receiving food and bleedout.}

Message property BleedoutMessage auto
Message property BleedoutMessageHELP auto

event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	(GetOwningQuest() as Mumirnik_Quest_Instincts_Feeding).ReceiveFood(self.GetActorReference(), akBaseItem, aiItemCount)
endEvent

event OnEnterBleedout()
	BleedoutMessage.Show()
	BleedoutMessageHELP.ShowAsHelpMessage("PetBleedout", 8.0, 1.0, 1)
endEvent