extends Node2D

var selected

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func createBuildMenu(obj):
	selected = obj
	var b = load("res://scene/BuildMenu.tscn").instantiate()
	b.position = get_local_mouse_position()
	add_child(b)

func cleanSelected():
	selected = null
