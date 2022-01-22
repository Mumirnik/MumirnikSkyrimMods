Scriptname Mumirnik_Quest_LaunchOtherQuest extends Quest  
{This quest will launch another quest after a delay. Use this to avoid cart glitches and other game start shenanigans.}

float property LaunchDelay auto
Quest property LaunchQuest auto

event OnInit()

	RegisterForSingleUpdate(LaunchDelay)

endEvent

event OnUpdate()

	LaunchQuest.Start()

endEvent