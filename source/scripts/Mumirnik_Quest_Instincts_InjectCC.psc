Scriptname Mumirnik_Quest_Instincts_InjectCC extends Quest  
{Adds CC items to the food lists. This is mostly hardcoded, while a softcoded solution can be found in the repository, the large number of both formlists and items makes it impractical in this case.}

import Debug
import Game

float property RunDelay auto
{This is used in some other people's scripts, I assume it prevents the cart glitch.}
FormList property DestinationFormListEverything auto
FormList property DestinationFormListFish auto
FormList property DestinationFormListMeat auto
FormList property DestinationFormListMeatFish auto
FormList property DestinationFormListVegetables auto
FormList property DestinationFormListVegetablesMeatFish auto

int added = 0

event OnInit()
	RegisterForSingleUpdate(RunDelay)
endEvent

event OnUpdate()
	Trace("Instincts: Start CC injection", 0)
	AddFishing()
	AddCurios()
	AddCause()
	AddZombies()
	AddPuzzleDungeon()
	Trace("Instincts: Finish CC injection, added " + added + " items", 0)
endEvent

function AddFishing()
	Form item = NONE
	item = GetFormFromFile(0x000008EB, "ccBGSSSE001-Fish.esm")
	if (!item)
		Trace("Instincts: Fishing not installed", 0)
		return
	endIf
	AddToFormListsFish(GetFormFromFile(0x000008EB, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x000008EC, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x000008ED, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x000008EE, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x000008EF, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x000008F0, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x000008F1, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x000008F2, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x000008F3, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x0000087A, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x0000087B, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x0000087C, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x0000087D, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x0000087E, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x0000087F, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000880, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000881, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000882, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000883, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000884, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000885, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000886, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000887, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000888, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x0000088A, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x0000088B, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x0000088C, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x0000088D, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x0000088E, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x0000088F, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000890, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000891, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000896, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000897, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000898, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x0000089A, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x0000089B, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x0000089C, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x0000089E, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x000008A0, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x000008A1, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x000008A2, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x000008A3, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x000008A4, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x000008A5, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000BB7, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000C2D, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000EFE, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000F02, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000F04, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000F06, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000F0A, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000F0B, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000F0C, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000F25, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000F76, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000F77, "ccBGSSSE001-Fish.esm"))
	AddToFormListsFish(GetFormFromFile(0x00000F78, "ccBGSSSE001-Fish.esm"))
endFunction

function AddCurios()
	Form item = NONE
	item = GetFormFromFile(0x00001802, "ccBGSSSE037-Curios.esl")
	if (!item)
		Trace("Instincts: Curios not installed", 0)
		return
	endIf
	AddToFormListsVegetables(GetFormFromFile(0x00001802, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x00001804, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x00001805, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x00001806, "ccBGSSSE037-Curios.esl"))
	AddToFormListsEverything(GetFormFromFile(0x00001807, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x00001809, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x0000180A, "ccBGSSSE037-Curios.esl"))
	AddToFormListsEverything(GetFormFromFile(0x0000180B, "ccBGSSSE037-Curios.esl"))
	AddToFormListsMeat(GetFormFromFile(0x0000180C, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x0000180D, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x0000180E, "ccBGSSSE037-Curios.esl"))
	AddToFormListsEverything(GetFormFromFile(0x0000180F, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x00001811, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x00001813, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x00001814, "ccBGSSSE037-Curios.esl"))
	AddToFormListsEverything(GetFormFromFile(0x00001815, "ccBGSSSE037-Curios.esl"))
	AddToFormListsEverything(GetFormFromFile(0x00001816, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x00001817, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x00001818, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x00001819, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x0000181A, "ccBGSSSE037-Curios.esl"))
	AddToFormListsFish(GetFormFromFile(0x0000181B, "ccBGSSSE037-Curios.esl"))
	AddToFormListsMeat(GetFormFromFile(0x0000181C, "ccBGSSSE037-Curios.esl"))
	AddToFormListsMeat(GetFormFromFile(0x0000181D, "ccBGSSSE037-Curios.esl"))
	AddToFormListsEverything(GetFormFromFile(0x0000181E, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x0000181F, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x00001821, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x00001822, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x00001823, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x00001824, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x00001825, "ccBGSSSE037-Curios.esl"))
	AddToFormListsEverything(GetFormFromFile(0x00001826, "ccBGSSSE037-Curios.esl"))
	AddToFormListsEverything(GetFormFromFile(0x00001827, "ccBGSSSE037-Curios.esl"))
	AddToFormListsEverything(GetFormFromFile(0x00001828, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x00001829, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x0000182A, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x0000182B, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x0000182C, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x0000182D, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x0000182E, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x00001836, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x00001837, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x00001838, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x00001D62, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x00001D66, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x00001D68, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x00001D6A, "ccBGSSSE037-Curios.esl"))
	AddToFormListsVegetables(GetFormFromFile(0x00001D6C, "ccBGSSSE037-Curios.esl"))
endFunction

function AddCause()
	Form item = NONE
	item = GetFormFromFile(0x00024C11, "ccBGSSSE067-daedinv.esm")
	if (!item)
		Trace("Instincts: Cause not installed", 0)
		return
	endIf
	AddToFormListsVegetables(GetFormFromFile(0x00024C11, "ccBGSSSE067-daedinv.esm"))
	AddToFormListsVegetables(GetFormFromFile(0x00024C13, "ccBGSSSE067-daedinv.esm"))
	AddToFormListsVegetables(GetFormFromFile(0x00024C15, "ccBGSSSE067-daedinv.esm"))
endFunction

function AddZombies()
	Form item = NONE
	item = GetFormFromFile(0x0000080C, "ccBGSSSE003-zombies.esl")
	if (!item)
		Trace("Instincts: Zombies not installed", 0)
		return
	endIf
	AddToFormListsMeat(GetFormFromFile(0x0000080C, "ccBGSSSE003-zombies.esl"))
endFunction

function AddPuzzleDungeon()
	Form item = NONE
	item = GetFormFromFile(0x00019D3A, "cctwbsse001-puzzledungeon.esm")
	if (!item)
		Trace("Instincts: Puzzle Dungeon not installed", 0)
		return
	endIf
	AddToFormListsVegetables(GetFormFromFile(0x00019D20, "cctwbsse001-puzzledungeon.esm"))
	AddToFormListsMeat(GetFormFromFile(0x0003326A, "cctwbsse001-puzzledungeon.esm"))
	AddToFormListsMeat(GetFormFromFile(0x00019D3A, "cctwbsse001-puzzledungeon.esm"))
endFunction

function AddToFormListsEverything(Form akItem)
	DestinationFormListEverything.AddForm(akItem)
	added += 1
endFunction

function AddToFormListsVegetables(Form akItem)
	DestinationFormListEverything.AddForm(akItem)
	DestinationFormListVegetables.AddForm(akItem)
	DestinationFormListVegetablesMeatFish.AddForm(akItem)
	added += 1
endFunction

function AddToFormListsMeat(Form akItem)
	DestinationFormListEverything.AddForm(akItem)
	DestinationFormListMeat.AddForm(akItem)
	DestinationFormListMeatFish.AddForm(akItem)
	DestinationFormListVegetablesMeatFish.AddForm(akItem)
	added += 1
endFunction

function AddToFormListsFish(Form akItem)
	DestinationFormListEverything.AddForm(akItem)
	DestinationFormListFish.AddForm(akItem)
	DestinationFormListMeatFish.AddForm(akItem)
	DestinationFormListVegetablesMeatFish.AddForm(akItem)
	added += 1
endFunction