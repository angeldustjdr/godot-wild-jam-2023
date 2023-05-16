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
