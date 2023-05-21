extends Node2D

var selected # hold the cell to build onto
@onready var juicyLabel = preload("res://scene/JuicyLabel.tscn")
@onready var GameOverTitle = preload("res://scene/GameOverTitle.tscn")

func _ready(): # signal connexion
	RadioDiffusion.connect("cleanSelectionNeeded",cleanSelected)
	RadioDiffusion.connect("createBuildMenuNeeded",createBuildMenu)
	RadioDiffusion.connect("createConfirmMenuNeeded",createConfirmMenu)
	RadioDiffusion.connect("popLabelNeeded",popLabel)
	RadioDiffusion.connect("updateTopUINeeded",ambianceManager)
	GameState.connect("GameOver",GameOver)
	$Grid.connect("gridUpdated",checkPatterns)
	
	GameState.ressourceInit(1000,16,16,16)
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
	RadioDiffusion.updateTopUICall()

func ambianceManager():
	var lowTechFood = GameState.ressource["FOOD"]-GameState.ressourceHighTech["FOOD"]
	var lowTechWater = GameState.ressource["WATER"]-GameState.ressourceHighTech["WATER"]
	var lowTechO2 = GameState.ressource["O2"]-GameState.ressourceHighTech["O2"]
	var pourcentGlobal = clamp(((lowTechFood+lowTechO2+lowTechWater)/3)/(GameState.maxStat/2.),0,1)
	$AmbiantParticules.amount = clamp(int(pourcentGlobal*15)+1,1,20)
	$WorldEnvironment.environment.glow_bloom = pourcentGlobal*0.5
	$CanvasModulate.color = Color(1,1,1-(pourcentGlobal*0.05))

func GameOver():
	RadioDiffusion.nextDialogNeeded("pop_neg")
	var g = GameOverTitle.instantiate()
	add_child(g)
