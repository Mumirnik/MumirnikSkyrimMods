Scriptname Mumirnik_Quest_AddSpellsToListsSetup extends Quest  

import Debug

Actor property PlayerRef auto
Book[] property SpellTomesList auto
Book[] property SpellTomesSpecialList auto
{Master spell tomes are added in a form list.}
Float property RunDelay auto
{This is used in some other people's scripts, I assume it prevents the cart glitch.}
LeveledItem[] property SpellTomesLootItemsList auto
LeveledItem[] property SpellStavesLootItemsList auto
LeveledItem[] property SpellScrollsLootItemsList auto
FormList[] property SpellTomesSpecialFormListsList auto
Scroll[] property SpellScrollsList auto
Weapon[] property SpellStavesList auto

event OnInit()
	RegisterForSingleUpdate(RunDelay)
endEvent

event OnUpdate()
	if (SpellTomesList.Length != SpellTomesLootItemsList.Length || SpellStavesList.Length != SpellStavesLootItemsList.Length || SpellScrollsList.Length != SpellScrollsLootItemsList.Length)
		MessageBox("Error: Spell lists don't have the same length, spells will not be added to leveled items")
		return
	endIf
	int i = 0
	while (i < SpellTomesLootItemsList.Length - 1)
		SpellTomesLootItemsList[i].AddForm(SpellTomesList[i], 1, 1)
		i += 1
	endWhile
	int j = 0
	while (j < SpellStavesLootItemsList.Length - 1)
		SpellStavesLootItemsList[j].AddForm(SpellStavesList[j], 1, 1)
		j += 1
	endWhile
	int k = 0
	while (k < SpellScrollsLootItemsList.Length - 1)
		SpellScrollsLootItemsList[k].AddForm(SpellScrollsList[k], 1, 1)
		k += 1
	endWhile
	int l = 0
	while (l < SpellTomesSpecialList.Length - 1)
		SpellTomesSpecialFormListsList[l].AddForm(SpellTomesSpecialList[l])
		l += 1
	endWhile

endEvent