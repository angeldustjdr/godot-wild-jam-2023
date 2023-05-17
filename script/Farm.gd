extends GenericBuilding
class_name Farm

var _heat_modifier_value = -5
var _big_modifier_value = 1
var _irrigated_modifier_value = 1


func _on_input_event(_viewport, _event, _shape_idx):
	pass

func applyPatternModifier(pattern):
	if pattern is FourFieldsPattern:
		patternModifier["FOOD"] = _big_modifier_value
	else:
		print("Farm:applyModifier:ERROR: pattern is unknown.")
	popLabel(getTotalStat())

func applyEffectModifier(effectName):
	match effectName:
		"Heat" :
				modifier["FOOD"] += _heat_modifier_value
				unsetHourglass()
		"Pollution" :
				modifier["FOOD"] = -5
				unsetHourglass()
		"Smoke" :
				modifier["FOOD"] = -5
				unsetHourglass()
		"Fertilizer" :
				modifier["FOOD"] = +3
				unsetHourglass()
		"Spore" :
				modifier["FOOD"] = 0
				unsetHourglass()
		"Meat" :
				modifier["FOOD"] = -5
				hourglassTimer = 5
				setHourglass()
		"Nothing" :
				modifier["FOOD"] = 0
				unsetHourglass()
	popLabel(getTotalStat())

func setLock():
	pass

func unsetLock():
	pass
