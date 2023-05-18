extends Node2D

var selected # hold the cell to build onto
@onready var juicyLabel = preload("res://scene/JuicyLabel.tscn")

func _ready(): # signal connexion
	RadioDiffusion.connect("cleanSelectionNeeded",cleanSelected)
	RadioDiffusion.connect("createBuildMenuNeeded",createBuildMenu)
	RadioDiffusion.connect("createConfirmMenuNeeded",createConfirmMenu)
	RadioDiffusion.connect("popLabelNeeded",popLabel)
	$Grid.connect("gridUpdated",checkPatterns)
	
	GameState.ressourceInit(1000,12,12,12)
	RadioDiffusion.updateTopUICall()

func createBuildMenu(obj):
	selected = obj
	var b = load("res://scene/BuildMenu.tscn").instantiate()
	b.position = get_local_mouse_position()
	add_child(b)
	
func createConfirmMenu(obj):
	selected = obj
	var b = load("res://scene/ConfirmMenu.tscn").instantiate()
	b.position = get_local_mouse_position()
	add_child(b)

func checkPatterns(i,j):
	var grid = self.get_node("Grid")
	for pattern in $Patterns.get_children():
		if(pattern.check(j,i,grid)):
			pattern.apply(grid)
	grid.calculateRessources()

func cleanSelected():
	selected = null

func popLabel(pos,text,dir):
	var j = juicyLabel.instantiate()
	add_child(j)
	j.init(pos,text,dir)


func _on_pass_turn_button_pressed():
	GameState.increaseNbAction()
