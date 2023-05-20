extends Control

@onready var startingPoint = "start"
@onready var dialog = load("res://scene/DialogueText.tscn")
@onready var first = true


func _on_label_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
			if first :
				$Label.queue_free()
				var d = dialog.instantiate()
				add_child(d)
				first = false
			
			
