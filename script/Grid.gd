extends Node2D

var tileSize:int = 68 # in pixel
var Xmax = 6
var Ymax = 5
var grid = Array() #holds the buildings in a 2d matrix. Warning, X and Y are based on godot x and y axis (oriented weirdly)
var sourceEffectGrid = Array() #holds the source of effect
var effectGrid = Array() #holds the effects

var rng = RandomNumberGenerator.new()

var building = {"Generic" : load("res://scene/GenericBuilding.tscn"),
				"Heat" : load("res://scene/HeatBuilding.tscn"),
				"Empty" : load("res://scene/Empty.tscn"),
				"Farm" :  load("res://scene/Farm.tscn"),
				"Well" :  load("res://scene/Well.tscn"),
				"Tree" :  load("res://scene/Tree.tscn"),
				"SuperWater" : load("res://scene/SuperWaterGenerator.tscn"),
				"SuperFood" : load("res://scene/SuperFoodGenerator.tscn"),
				"SuperO2" : load("res://scene/SuperO2Generator.tscn")}

var requiredBuilding = {"SuperWater" : 2, "SuperFood" : 2, "SuperO2" : 2} # number of special buildings
var genericBuildingChoiceWeight = {"Generic" : 90, "Heat" : 10} # probability of getting the initial generic building

signal gridUpdated(x,y)

func _ready():
	RadioDiffusion.connect("gridUpdateNeeded",gridUpdate)
	RadioDiffusion.connect("recalculateEffectNeeded",recalculateEffect)
	RadioDiffusion.connect("calculateRessourcesNeeded",calculateRessources)
	fillInitialGrid()
	calculateRessources()

func getCell(i,j): # i = line number and j = column number
	if (i >= self.Ymax or j >= self.Xmax):
		return null
	else:
		return self.grid[j][i]

func fillInitialGrid() -> void:
	#fill grids with nothing
	var myGrid = Array()
	for i in Xmax:
		var col = Array()
		for j in Ymax:
			col.append(null)
		myGrid.append(col)
	grid = myGrid.duplicate(true)
	sourceEffectGrid = myGrid.duplicate(true)
	
	#fill with required buildings
	var alreadyFilled = []
	for required in requiredBuilding.keys():
		for N in requiredBuilding[required]:
			var X_rng = rng.randi_range(0,Xmax-1)
			var Y_rng = rng.randi_range(0,Ymax-1)
			while [X_rng,Y_rng] in alreadyFilled :
				X_rng = rng.randi_range(0,Xmax-1)
				Y_rng = rng.randi_range(0,Ymax-1)
			alreadyFilled.append([X_rng,Y_rng])
			var newBuilding = popBuilding(required,X_rng,Y_rng)
			grid[X_rng][Y_rng] = newBuilding
			sourceEffectGrid[X_rng][Y_rng] = newBuilding.effect
	
	#fill with the other ones
	var genericBuildingChoice = []
	for g in genericBuildingChoiceWeight.keys():
		for w in genericBuildingChoiceWeight[g]:
			genericBuildingChoice.append(g)
	for i in Xmax:
		for j in Ymax:
			if [i,j] not in alreadyFilled:
				genericBuildingChoice.shuffle()
				var newBuilding = popBuilding(genericBuildingChoice[0],i,j)
				grid[i][j] = newBuilding
				sourceEffectGrid[i][j] = newBuilding.effect
	recalculateEffect()


func gridUpdate(x,y,type): #pops a building of type at [x,y]
	var newBuilding = popBuilding(type,x,y)
	grid[x][y] = newBuilding
	sourceEffectGrid[x][y] = self.grid[x][y].effect
	recalculateEffect()
	calculateRessources()
	GameState.actionnable_on()
	GameState.increaseNbAction()
	RadioDiffusion.cleanSelectedCall()
	gridUpdated.emit(x,y)
	
func popBuilding(type,x,y):
	var b = building[type].instantiate()
	b.global_position = Vector2(x*tileSize,y*tileSize)
	b.i = x
	b.j = y
	add_child(b)
	return b

func calculateRessources():
	var recalculatedRessource = {"WATER" : 0,"FOOD" : 0,"O2" : 0}
	for build in get_children():
		for n in recalculatedRessource.keys():
			build.getTotalStat()
			recalculatedRessource[n] += build.totalStat[n]
	GameState.fillRessource(recalculatedRessource)
	if GameState.checkPop: GameState.calculatePop()
	RadioDiffusion.updateTopUICall()

func recalculateEffect():
	effectGrid = sourceEffectGrid.duplicate(true)
	for i in Xmax:
		for j in Ymax:
			var neighbours = [[i,j-1],[i,j+1],[i-1,j],[i+1,j]]
			match  sourceEffectGrid[i][j]:
				"Heat": 
					for ij in neighbours:
						var i_n = clamp(ij[0],0,Xmax-1)
						var j_n = clamp(ij[1],0,Ymax-1)
						if sourceEffectGrid[i_n][j_n] == "Nothing": effectGrid[i_n][j_n]="Heat"
	applyEffect()

func applyEffect():
	for n in get_children():
		match effectGrid[n.i][n.j]:
			"Heat":
				var heatParticle = load("res://scene/HeatParticules.tscn")
				var h = heatParticle.instantiate()
				n.add_child(h)
				n.applyCellEffect("Heat")
			"Nothing":
				n.cleanParticules()

func cleanNode():
	for n in get_children():
		n.queue_free()
