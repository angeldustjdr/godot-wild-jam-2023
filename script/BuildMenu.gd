extends VBoxContainer

@onready var main = get_parent()

func _ready():
	GameState.menuOpened = true
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_RIGHT and event.pressed:
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
	GameState.menuOpened = false
	queue_free()
