extends GenericBuilding
class_name Farm

func _on_input_event(_viewport, _event, _shape_idx):
	pass

func applyEffectModifier(effectName):
	match effectName:
		"Heat" :
				modifier["FOOD"] -= 5
		"Nothing" :
				modifier["FOOD"] = 0
	popLabel(getTotalStat())
