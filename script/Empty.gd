extends GenericBuilding

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and GameState.actionnable:
		if event.button_index==MOUSE_BUTTON_LEFT:
			GameState.actionnable_off()
			createBuildMenu(self)

func createBuildMenu(obj):
	RadioDiffusion.createBuildMenuCall(obj)

