extends GenericBuilding
class_name myTree # Tree is already a class in godot4

var _big_modifier_value = 1

func applyPatternModifier(pattern):
	if pattern is FourTreesPattern:
		modifier["O2"] += _big_modifier_value
	else:
		print("myTree:applyModifier:ERROR: pattern is unknown.")
	popLabel(getTotalStat())

func _on_input_event(_viewport, _event, _shape_idx):
	pass

func applyEffectModifier(effectName):
	match effectName:
		"Heat" :
				modifier["O2"] -= 5
				hourglassTimer = 5
				setHourglass()
		"Pollution" :
				modifier["O2"] -= 5
		"Smoke" :
				modifier["O2"] -= 5
		"Nothing" :
				modifier["O2"] = 0
				unsetHourglass()
	popLabel(getTotalStat())

func setLock():
	pass

func unsetLock():
	pass
