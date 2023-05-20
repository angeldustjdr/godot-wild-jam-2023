extends VBoxContainer

@onready var main = get_parent()

func _ready():
	GameState.menuOpened = true

func _input(event):
	if event is InputEventMouseButton and !GameState.actionnable:
		if event.button_index==MOUSE_BUTTON_RIGHT:
			freeMenu()

func _on_destroy_pressed():
	if main.selected != null:
		main.selected.selfDestruct("Empty")
	freeMenu()

func _on_cancel_pressed():
	freeMenu()

func freeMenu():
	GameState.menuOpened = false
	queue_free()



