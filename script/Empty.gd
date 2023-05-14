extends GenericBuilding

var menu = load("res://scene/BuildMenu.tscn")

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and GameState.actionnable:
		if event.button_index==MOUSE_BUTTON_LEFT:
			GameState.actionnable_off()
			createBuildMenu()

func createBuildMenu():
	var m = menu.instantiate()
	m.position = get_local_mouse_position()
	add_child(m)

