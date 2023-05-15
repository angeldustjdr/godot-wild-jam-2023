extends GenericBuilding
class_name Farm

func _on_input_event(_viewport, _event, _shape_idx):
	pass

func applyCellEffect(myEffect):
	if cellEffect=="Nothing":
		cellEffect=myEffect
		match cellEffect:
			"Heat" :
				modifier["FOOD"] -= 5
				getTotalStat()
