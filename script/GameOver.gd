extends Control

func _process(_delta):
	GameState.actionnable = false


func _on_gui_input(event):
		if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
			if first :
				$Label.queue_free()
				var d = dialog.instantiate()
				add_child(d)
				first = false
