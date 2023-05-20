extends Control

@onready var rideau = get_parent().get_node("Rideau/AnimationPlayer")

func _process(_delta):
	GameState.actionnable = false


func _on_color_rect_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
			rideau.play("rideau_out")
			await rideau.animation_finished
			GameState.reset()
			get_tree().change_scene_to_file("res://Main.tscn")
