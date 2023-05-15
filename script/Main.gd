extends Node2D

var selected # hold the cell to build onto

func _ready(): # signal connexion
	RadioDiffusion.connect("cleanSelectionNeeded",cleanSelected)
	RadioDiffusion.connect("createBuildMenuNeeded",createBuildMenu)
	$Grid.connect("gridUpdated",checkPatterns)
	
	GameState.ressourceInit(1000,12,12,12)
	RadioDiffusion.updateTopUICall()

func createBuildMenu(obj):
	selected = obj
	var b = load("res://scene/BuildMenu.tscn").instantiate()
	b.position = get_local_mouse_position()
	add_child(b)

func checkPatterns(i,j):
	for pattern in $Patterns.get_children():
		pattern.check(i,j)
	pass

func cleanSelected():
	selected = null
