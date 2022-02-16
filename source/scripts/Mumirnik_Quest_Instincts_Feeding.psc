Scriptname Mumirnik_Quest_Instincts_Feeding extends Quest  
{Handles pet feeding. Exposes functions to start feeding or receive food.}

import debug

float property GoldToHungerIngredientAdd auto
{This is added to the gold cost of an ingredient to determine its hunger restore.}
float property GoldToHungerIngredientMult auto
{This is multiplied by the gold cost of an ingredient to determine its hunger restore.}
float property GoldToHungerPotionAdd auto
{This is added to the gold cost of a potion to determine its hunger restore.}
float property GoldToHungerPotionMult auto
{This is multiplied by the gold cost of a potion to determine its hunger restore.}
FormList property EmptyList auto
FormList property FoodSublists auto
FormList property FoodTypes auto
FormList property FullList auto
Sound property EatSound auto

function Feed(Actor akTarget)
{Open the inventory dialog box to feed target pet. Will throw if the pet is an invalid race or does not have a food list.}
	int actorId = ((self as Quest) as Mumirnik_Quest_Instincts_PetOptions).GetRaceIdForTamedAnimal(akTarget)
	GlobalVariable foodType = FoodTypes.GetAt(actorId) as GlobalVariable
	FormList foodListForActor = FoodSublists.GetAt(foodType.GetValue() as int) as FormList
	if (!foodListForActor)
		MessageBox("Error: No food list for actor")
		return
	endIf

	akTarget.ModActorValue("CarryWeight", 100)
	akTarget.AddInventoryEventFilter(foodListForActor)
	akTarget.ShowGiftMenu(true, foodListForActor, true, false)
	akTarget.ModActorValue("CarryWeight", -100)
endFunction

FormList function GetFoodListForOriginalRace(Actor akTarget)
{Gets the food list for the target actor's race.}
	FormList originalRaceList = ((self as Quest) as Mumirnik_Quest_Instincts_PetOptions).OriginalRaceList
	int raceId = -1
	raceId = originalRaceList.Find(akTarget.GetRace())
	if (raceId == -1)
		MessageBox("Error: Unknown actor race")
		return EmptyList
	endIf

	GlobalVariable foodType = FoodTypes.GetAt(raceId) as GlobalVariable
	FormList foodListForRace = FoodSublists.GetAt(foodType.GetValue() as int) as FormList
	if (!foodListForRace)
		return FullList
	endIf
	return foodListForRace
endFunction

function ReceiveFood(Actor akTarget, Form afFoodItem, int aiCount)
{Called from the pet REF that is receiving food. Handles vfx and stat increases.}
	EatSound.Play(akTarget)

	float itemValue = 0
	if (afFoodItem as Ingredient)
		itemValue = (afFoodItem.GetGoldValue() * GoldToHungerIngredientMult) + GoldToHungerIngredientAdd
	elseIf (afFoodItem as Potion)
		itemValue = (afFoodItem.GetGoldValue() * GoldToHungerPotionMult) + GoldToHungerPotionAdd
	else
		itemValue = afFoodItem.GetGoldValue()
	endIf
	itemValue *= aiCount

	int slotNumber = ((self as Quest) as Mumirnik_Quest_Instincts_PetOptions).GetSlotNumberForActor(akTarget)
	((self as Quest) as Mumirnik_Quest_Instincts_PetStats).ModHunger(akTarget, itemValue as int)
	((self as Quest) as Mumirnik_Quest_Instincts_PetStats).HungerChangeMessage[slotNumber].Show(-itemValue)

	akTarget.RemoveItem(afFoodItem, aiCount)
endFunction