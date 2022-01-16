Scriptname Mumirnik_Quest_UseFurniture extends Quest  
{Exposes methods to force the player to use created furniture and delete it when they stand up.}

import Utility

Actor property PlayerREF auto
float property CheckUsageRate auto
float property HeightOffset auto
int property NumberOfTries auto

ObjectReference FurnitureREF

int function UseFurniture(Furniture akFurniture)
{Creates a furniture at the player's feet and uses it. The furniture is deleted when the player stands up. Returns 1 if successful, 0 if player is sitting on something else, -1 if failed.}
	int sitState = PlayerREF.GetSitState()
	if (sitState == 0)
		FurnitureREF = PlayerREF.PlaceAtMe(akFurniture, abInitiallyDisabled = true)
		float zAngle = PlayerREF.GetAngleZ()
		if (HeightOffset != 0)
			FurnitureREF.MoveTo(PlayerREF, 0.0, 0.0, HeightOffset)
		endIf
		FurnitureREF.SetAngle(0.0, 0.0, zAngle)
		FurnitureREF.Enable()
		FurnitureREF.Activate(PlayerREF, true)

		int i = 0
		while (PlayerRef.GetSitState() != 3 && i < NumberOfTries)
			Wait(CheckUsageRate)
			i += 1
		endWhile

		if (i >= NumberOfTries)
			FurnitureREF.Disable(true)
			FurnitureREF.Delete()
			return -1
		else
			RegisterForSingleUpdate(CheckUsageRate)
			return 1
		endIf
	elseIf (sitState == 3)
		return 0
	else
		return -1
	endIf
endFunction

event OnUpdate()
	if (PlayerREF.GetSitState() != 0)
		RegisterForSingleUpdate(CheckUsageRate)
	else
		FurnitureREF.Disable(true)
		FurnitureREF.Delete()
	endIf
endEvent