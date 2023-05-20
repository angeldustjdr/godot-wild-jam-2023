extends Control

func _ready():
	RadioDiffusion.connect("rideauFinished",changeScene)

func _process(_delta):
	GameState.actionnable = false


func _on_color_rect_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
			RadioDiffusion.rideauCall("out")

func changeScene():
	GameState.reset()
	get_tree().change_scene_to_file("res://Main.tscn")
