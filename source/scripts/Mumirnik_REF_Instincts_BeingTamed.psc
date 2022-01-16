Scriptname Mumirnik_REF_Instincts_BeingTamed extends ReferenceAlias  

float property GoldToTamingStrengthIngredientAdd auto
float property GoldToTamingStrengthIngredientMult auto
float property GoldToTamingStrengthPotionAdd auto
float property GoldToTamingStrengthPotionMult auto

event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)

	Actor thisActor = GetActorReference()
	Quest owningQuest = GetOwningQuest()

	Sound eatSound = (owningQuest as Mumirnik_Quest_Instincts_Feeding).EatSound
	eatSound.Play(thisActor)

	float itemValue = 0
	if (akBaseItem as Ingredient)
		itemValue = (akBaseItem.GetGoldValue() * GoldToTamingStrengthIngredientMult) + GoldToTamingStrengthIngredientAdd
	elseIf (akBaseItem as Potion)
		itemValue = (akBaseItem.GetGoldValue() * GoldToTamingStrengthPotionMult) + GoldToTamingStrengthPotionAdd
	else
		itemValue = akBaseItem.GetGoldValue()
	endIf
	itemValue *= aiItemCount

	(owningQuest as Mumirnik_Quest_Instincts_PetOptions).MakePet(thisActor)

endEvent