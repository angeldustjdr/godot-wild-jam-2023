extends VBoxContainer

@onready var main = get_parent()

	
func _input(event):
	if event is InputEventMouseButton and !GameState.actionnable:
		if event.button_index==MOUSE_BUTTON_RIGHT:
			freeMenu()

func _on_farm_button_pressed():
	if main.selected != null:
		main.selected.selfDestruct("Farm")
	freeMenu()


func _on_tree_button_pressed():
	if main.selected != null:
		main.selected.selfDestruct("Tree")
	freeMenu()


func _on_well_button_pressed():
	if main.selected != null:
		main.selected.selfDestruct("Well")
	freeMenu()


func _on_cancel_pressed():
	freeMenu()

func freeMenu():
	queue_free()
