extends Node2D

var tileSize:int = 68 # in pixel
var Xmax = 6
var Ymax = 5
var grid #holds the buildings in a 2d matrix. Warning, X and Y are based on godot x and y axis (oriented weirdly)

var rng = RandomNumberGenerator.new()

var building = {"Generic" : load("res://scene/GenericBuilding.tscn"),
				"Empty" : load("res://scene/Empty.tscn"),
				"Farm" :  load("res://scene/Farm.tscn"),
				"Well" :  load("res://scene/Well.tscn"),
				"Tree" :  load("res://scene/Tree.tscn"),
				"SuperWater" : load("res://scene/SuperWaterGenerator.tscn"),
				"SuperFood" : load("res://scene/SuperFoodGenerator.tscn"),
				"SuperO2" : load("res://scene/SuperO2Generator.tscn")}

func _ready():
	RadioDiffusion.connect("gridUpdateNeeded",gridUpdate)
	fillInitialGrid()

func _process(_delta):
	calculateRessources(GameState.checkPop)

func fillInitialGrid() -> void:
	var requiredBuilding = {"SuperWater" : 2, "SuperFood" : 2, "SuperO2" : 2} # number of special buildings
	var requiredBuildingName = requiredBuilding.keys()
	var myGrid = Array()
	for i in Xmax:
		var col = Array()
		for j in Ymax:
			# ok, this way of filling the grid sucks ! it needs to be improved
			if requiredBuildingName == []:
				col.append(popBuilding("Generic",i,j))
			else:
				if rng.randf_range(0.,100.) > 50.:
					requiredBuildingName.shuffle()
					var elem = requiredBuildingName[0]
					col.append(popBuilding(elem,i,j))
					requiredBuilding[elem] -= 1
					if requiredBuilding[elem] <= 0 : requiredBuildingName.erase(elem)
				else:
					col.append(popBuilding("Generic",i,j))
		myGrid.append(col)
	grid = myGrid

func gridUpdate(x,y,type): #pops a building of type at [x,y]
	grid[x][y] = popBuilding(type,x,y)
	
func popBuilding(type,x,y):
	var b = building[type].instantiate()
	b.global_position = Vector2(x*tileSize,y*tileSize)
	b.i = x
	b.j = y
	add_child(b)
	return b

func calculateRessources(check):
	var recalculatedRessource = {"WATER" : 0,"FOOD" : 0,"O2" : 0}
	for build in get_children():
		for n in recalculatedRessource.keys():
			recalculatedRessource[n] += build.base_stat[n] + build.modifier[n]
	GameState.fillRessource(recalculatedRessource)
	if check: GameState.calculatePop()
	RadioDiffusion.updateTopUICall()

func cleanNode():
	for n in get_children():
		n.queue_free()
