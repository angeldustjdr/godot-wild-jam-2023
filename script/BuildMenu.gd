extends VBoxContainer

@onready var parent = get_parent()

func _input(event):
	if event is InputEventMouseButton and !GameState.actionnable:
		if event.button_index==MOUSE_BUTTON_RIGHT:
			freeMenu()

func _on_farm_button_pressed():
	parent.selfDestruct("Farm")
	freeMenu()


func _on_tree_button_pressed():
	parent.selfDestruct("Tree")
	freeMenu()


func _on_well_button_pressed():
	parent.selfDestruct("Well")
	freeMenu()


func _on_cancel_pressed():
	freeMenu()

func freeMenu():
	GameState.actionnable_on()
	queue_free()
