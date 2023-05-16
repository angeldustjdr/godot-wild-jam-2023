extends GenericBuilding
class_name Farm

var _heat_modifier_value = -5
var _big_modifier_value = 1
var _irrigated_modifier_value = 1


func _on_input_event(_viewport, _event, _shape_idx):
	pass

func applyPatternModifier(pattern):
	if pattern is FourFieldsPattern:
		modifier["FOOD"] += _big_modifier_value
	else:
		print("Farm:applyModifier:ERROR: pattern is unknown.")
	popLabel(getTotalStat())

func applyEffectModifier(effectName):
	match effectName:
		"Heat" :
				modifier["FOOD"] += _heat_modifier_value
#		"Nothing" :
#				modifier["FOOD"] = 0
	popLabel(getTotalStat())
