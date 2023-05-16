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
				"Pollution" : load("res://scene/PollutedBuilding.tscn"),
				"Empty" : load("res://scene/Empty.tscn"),
				"Farm" :  load("res://scene/Farm.tscn"),
				"Well" :  load("res://scene/Well.tscn"),
				"Tree" :  load("res://scene/Tree.tscn"),
				"SuperWater" : load("res://scene/SuperWaterGenerator.tscn"),
				"SuperFood" : load("res://scene/SuperFoodGenerator.tscn"),
				"SuperO2" : load("res://scene/SuperO2Generator.tscn")}

var requiredBuilding = {"SuperWater" : 2, "SuperFood" : 2, "SuperO2" : 2, "Heat" : 1, "Pollution" : 1} # number of special buildings
var genericBuildingChoiceWeight = {"Generic" : 90, "Heat" : 5, "Pollution" : 5} # probability of getting the initial generic building
var possibleOutcomes = {"RAS" : 75, "LOCK" : 25} #probability of outcomes
var emptyGrid = Array()

signal gridUpdated(x,y)

func _ready():
	RadioDiffusion.connect("gridUpdateNeeded",gridUpdate)
	RadioDiffusion.connect("recalculateEffectNeeded",recalculateEffect)
	RadioDiffusion.connect("calculateRessourcesNeeded",calculateRessources)
	RadioDiffusion.connect("generateOutcomeNeeded",generateOutcome)
	fillInitialGrid()
	calculateRessources()

func getCell(i,j): # i = line number and j = column number
	if (i >= self.Ymax or j >= self.Xmax):
		return null
	else:
		return self.grid[j][i]

func fillInitialGrid() -> void:
	#fill grids with nothing
	for i in Xmax:
		var col = Array()
		for j in Ymax:
			col.append(null)
		emptyGrid.append(col)
	grid = emptyGrid.duplicate(true)
	sourceEffectGrid = emptyGrid.duplicate(true)
	
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
	await get_tree().create_timer(0.3).timeout
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
	if GameState.checkPop: 
		GameState.calculatePop()
	RadioDiffusion.updateTopUICall()

func recalculateEffect():
	var bufferGrid = emptyGrid.duplicate(true)
	for i in Xmax:
		for j in Ymax:
			var neighbours = [[i,j-1],[i,j+1],[i-1,j],[i+1,j],[i,j]]
			for ij in neighbours:
				var i_n = clamp(ij[0],0,Xmax-1)
				var j_n = clamp(ij[1],0,Ymax-1)
				if bufferGrid[i_n][j_n] == null: bufferGrid[i_n][j_n] = [sourceEffectGrid[i][j]]
				else : bufferGrid[i_n][j_n].append(sourceEffectGrid[i][j])

	effectGrid = emptyGrid.duplicate(true)
	for i in Xmax:
		for j in Ymax:
			if bufferGrid[i][j].size() == 1 : effectGrid[i][j] = bufferGrid[i][j][0]
			else :
				if "Heat" in bufferGrid[i][j] :
					if "Pollution" in bufferGrid[i][j]:
						effectGrid[i][j] = "Smoke"
					else :
						effectGrid[i][j] = "Heat"
				elif "Pollution" in bufferGrid[i][j]:
					if "Heat" in bufferGrid[i][j]:
						effectGrid[i][j] = "Smoke"
					else :
						effectGrid[i][j] = "Pollution"
				else :
					effectGrid[i][j] = "Nothing"
	applyEffect()

func applyEffect():
	for n in get_children():
		if n.cellEffect != effectGrid[n.i][n.j]:
			n.cleanParticules()
		n.applyCellEffect(effectGrid[n.i][n.j])

func cleanNode():
	for n in get_children():
		n.queue_free()

func generateOutcome():
	var outcome = Array()
	for o in possibleOutcomes.keys():
		for p in possibleOutcomes[o]:
			outcome.append(o)
	outcome.shuffle()
	var i = randi_range(0,Xmax-1)
	var j = randi_range(0,Ymax-1)
	while grid[i][j].hasHourglass:
		i = randi_range(0,Xmax-1)
		j = randi_range(0,Ymax-1)
	match outcome[0]:
		"LOCK":
			grid[i][j].setLock()
		_ : pass
