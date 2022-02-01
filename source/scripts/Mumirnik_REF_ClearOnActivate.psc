Scriptname Mumirnik_REF_ClearOnActivate extends ReferenceAlias  
{When this REF is activated, clear it.}

Actor property ActivatorREF auto
{Activator REF. Leave empty for activations by any actor.}

event OnActivate(ObjectReference akActivator)
	if (!ActivatorREF || akActivator == ActivatorREF)
		self.Clear()
	endIf
endEvent