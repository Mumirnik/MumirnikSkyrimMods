Scriptname Mumirnik_Quest_Instincts_Behavior extends Quest  
{Handles pet behavior from dialogue calls.}

function WaitForPlayer(Actor akTarget, bool abWait = true)
{Toggle target between waiting for the player or not.}
	if (abWait)
		akTarget.SetActorValue("WaitingForPlayer", 1)
	else
		akTarget.SetActorValue("WaitingForPlayer", 0)
	endIf
	akTarget.EvaluatePackage()
endFunction