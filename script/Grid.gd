extends Node2D

var tileSize:int = 68 # in pixel
var Xmax = 6
var Ymax = 5
var grid = Array() #holds the buildings in a 2d matrix. Warning, X and Y are based on godot x and y axis (oriented weirdly)
var sourceEffectGrid = Array() #holds the source of effect
var effectGrid = Array() #holds the effects

var rng = RandomNumberGenerator.new()

var building = {"Generic" : preload("res://scene/GenericBuilding.tscn"),
				"Heat" : preload("res://scene/HeatBuilding.tscn"),
				"Pollution" : preload("res://scene/PollutedBuilding.tscn"),
				"Spore" : preload("res://scene/SporeBuilding.tscn"),
				"Empty" : preload("res://scene/Empty.tscn"),
				"Farm" :  preload("res://scene/Farm.tscn"),
				"Well" :  preload("res://scene/Well.tscn"),
				"Tree" :  preload("res://scene/Tree.tscn"),
				"SuperWater" : preload("res://scene/SuperWaterGenerator.tscn"),
				"SuperFood" : preload("res://scene/SuperFoodGenerator.tscn"),
				"SuperO2" : preload("res://scene/SuperO2Generator.tscn")}

@export var requiredBuilding = {"SuperWater" : 2, "SuperFood" : 2, "SuperO2" : 2, "Heat" : 2, "Pollution" : 2, "Spore" : 2} # number of special buildings
@export var possibleOutcomes = {"RAS" : 50, "LOCK" : 25, "SWAP" : 25} #probability of outcomes
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
	
	for i in Xmax:
		for j in Ymax:
			if [i,j] not in alreadyFilled:
				var newBuilding = popBuilding("Generic",i,j)
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

func calculateRessources(): # GB : could be optimized by considering only modified cells
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
				var uniqueSorted = []
				for elem in bufferGrid[i][j]:
					if elem not in uniqueSorted and elem!="Nothing": uniqueSorted.append(elem)
					uniqueSorted.sort()
				match uniqueSorted:
					["Heat"]: effectGrid[i][j] = "Heat"
					["Pollution"]: effectGrid[i][j] = "Pollution"
					["Spore"]: effectGrid[i][j] = "Spore"
					["Heat","Pollution"]: effectGrid[i][j] = "Smoke"
					["Heat","Spore"]: effectGrid[i][j] = "Fertilizer"
					["Pollution","Spore"]: effectGrid[i][j] = "Spore"
					["Heat","Pollution","Spore"] : effectGrid[i][j] = "Meat"
					_ : effectGrid[i][j] = "Nothing"
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
	var ok = false
	match outcome[0]:
		"LOCK":
			while not ok :
				var i = getRandomI()
				var j = getRandomJ()
				if grid[i][j].hasHourglass: 
					grid[i][j].setLock()
					ok=true
		"SWAP":
			while not ok:
				var i = getRandomI()
				var j = getRandomJ()
				var k = getRandomI()
				var l = getRandomJ()
				if [i,j]!=[k,l] and grid[i][j].swapable and grid[k][l].swapable:
					grid[i][j].swap(k,l,tileSize)
					grid[k][l].swap(i,j,tileSize)
					await get_tree().create_timer(1).timeout
					var bufferIJ = grid[i][j].duplicate()
					var bufferKL = grid[k][l].duplicate()
					grid[i][j] = bufferKL
					grid[k][l] = bufferIJ
					bufferIJ = sourceEffectGrid[i][j]
					bufferKL = sourceEffectGrid[k][l]
					sourceEffectGrid[i][j] = bufferKL
					sourceEffectGrid[k][l] = bufferIJ
					recalculateEffect()
					calculateRessources()
					ok = true
		_ : pass
		
func getRandomI():
	return randi_range(0,Xmax-1)
func getRandomJ():
	return randi_range(0,Ymax-1)
