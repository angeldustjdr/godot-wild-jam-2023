extends GenericBuilding

func _on_input_event(_viewport, event, _shape_idx):
	if not locked :
		if event is InputEventMouseButton and GameState.actionnable:
			if event.button_index==MOUSE_BUTTON_LEFT:
				GameState.actionnable_off()
				createBuildMenu(self)

func createBuildMenu(obj):
	RadioDiffusion.createBuildMenuCall(obj)

