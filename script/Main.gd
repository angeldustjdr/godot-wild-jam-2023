extends Node2D

var selected # hold the cell to build onto

func _ready(): # signal connexion
	RadioDiffusion.connect("cleanSelectionNeeded",cleanSelected)
	RadioDiffusion.connect("createBuildMenuNeeded",createBuildMenu)
	
	GameState.ressourceInit(1000,12,12,12)
	RadioDiffusion.updateTopUICall()

func createBuildMenu(obj):
	selected = obj
	var b = load("res://scene/BuildMenu.tscn").instantiate()
	b.position = get_local_mouse_position()
	add_child(b)

func cleanSelected():
	selected = null
