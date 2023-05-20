extends VBoxContainer

@onready var main = get_parent()

func _ready():
	GameState.menuOpened = true

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_RIGHT and event.pressed:
			freeMenu()
		if event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
			if get_global_mouse_position().x < global_position.x or get_global_mouse_position().x > global_position.x+size.x or get_global_mouse_position().y < global_position.y or get_global_mouse_position().y > global_position.y+size.y:
				freeMenu()

func _on_destroy_pressed():
	if main.selected != null:
		main.selected.selfDestruct("Empty")
	freeMenu()

func _on_cancel_pressed():
	GameState.menuOpened = false
	freeMenu()

func freeMenu():
	GameState.menuOpened = false
	queue_free()


