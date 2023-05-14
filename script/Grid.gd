extends Node2D

var tileSize:int = 68 # in pixel
@onready var Xmax = GameState.Xmax
@onready var Ymax = GameState.Ymax

var building = {"Generic" : load("res://scene/GenericBuilding.tscn"),
				"Empty" : load("res://scene/Empty.tscn"),
				"Farm" :  load("res://scene/Farm.tscn"),
				"Well" :  load("res://scene/Well.tscn"),
				"Tree" :  load("res://scene/Tree.tscn")}

# Called when the node enters the scene tree for the first time.
func _ready():
	RadioDiffusion.connect("gridUpdateNeeded",gridUpdate)
	fillInitialGrid()
	calculateRessources()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fillInitialGrid() -> void:
	var myGrid = Array()
	for i in Xmax:
		var col = Array()
		for j in Ymax:
			popBuilding("Generic",i,j)
			col.append("Generic")
		myGrid.append(col)
	GameState.setFullGrid(myGrid)
	calculateRessources()

func gridUpdate(x,y,type):
	GameState.setGrid(x,y,type)
	popBuilding(GameState.getCell(x,y),x,y)
	calculateRessources()
	
func popBuilding(type,x,y):
	var b = building[type].instantiate()
	b.global_position = Vector2(x*tileSize,y*tileSize)
	b.i = x
	b.j = y
	add_child(b)

func calculateRessources():
	var recalculatedRessource = {"POP" : 1000,"WATER" : 0,"FOOD" : 0,"O2" : 0}
	for building in get_children():
		for name in GameState.ressourceName:
			recalculatedRessource[name] += building.base_stat[name] + building.modifier[name]
	GameState.fillRessource(recalculatedRessource)
	RadioDiffusion.updateTopUICall()

func cleanNode():
	for n in get_children():
		n.queue_free()
