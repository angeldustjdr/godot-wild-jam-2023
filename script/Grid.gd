extends Node2D

var tileSize:int = 68 # in pixel
@onready var Xmax = GameState.Xmax
@onready var Ymax = GameState.Ymax
var rng = RandomNumberGenerator.new()

var building = {"Generic" : load("res://scene/GenericBuilding.tscn"),
				"Empty" : load("res://scene/Empty.tscn"),
				"Farm" :  load("res://scene/Farm.tscn"),
				"Well" :  load("res://scene/Well.tscn"),
				"Tree" :  load("res://scene/Tree.tscn"),
				"SuperWater" : load("res://scene/SuperWaterGenerator.tscn"),
				"SuperFood" : load("res://scene/SuperFoodGenerator.tscn"),
				"SuperO2" : load("res://scene/SuperO2Generator.tscn")}

# Called when the node enters the scene tree for the first time.
func _ready():
	RadioDiffusion.connect("gridUpdateNeeded",gridUpdate)
	fillInitialGrid()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	calculateRessources()

func fillInitialGrid() -> void:
	var requiredBuilding = {"SuperWater" : 2, "SuperFood" : 2, "SuperO2" : 2}
	var requiredBuildingName = requiredBuilding.keys()
	var myGrid = Array()
	for i in Xmax:
		var col = Array()
		for j in Ymax:
			if requiredBuildingName == []:
				popBuilding("Generic",i,j)
				col.append("Generic")
			else:
				if rng.randf_range(0.,100.) > 50.:
					requiredBuildingName.shuffle()
					var elem = requiredBuildingName[0]
					popBuilding(elem,i,j)
					col.append(elem)
					requiredBuilding[elem] -= 1
					if requiredBuilding[elem] <= 0 : requiredBuildingName.erase(elem)
				else:
					popBuilding("Generic",i,j)
					col.append("Generic")
		myGrid.append(col)
	GameState.setFullGrid(myGrid)

func gridUpdate(x,y,type):
	GameState.setGrid(x,y,type)
	popBuilding(GameState.getCell(x,y),x,y)
	
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
