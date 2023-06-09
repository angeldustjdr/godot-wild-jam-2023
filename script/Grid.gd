extends Node2D

var tileSize:int = 68 # in pixel
var Xmax = 6
var Ymax = 5
var grid = Array() #holds the buildings in a 2d matrix. Warning, X and Y are based on godot x and y axis (oriented weirdly)
var sourceEffectGrid = Array() #holds the source of effect
var effectGrid = Array() #holds the effects
var endGameDetected = false

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
@export var possibleOutcomes = {"RAS" : 30, "LOCK" : 30, "SWAP" : 30, "TIMER" : 20} #probability of outcomes
@onready var outcomeDialogueRAS = ["ras","toaster","strangeNoise","pipes","wifi","bank","ai","light","socialMedia"]
@onready var outComeOnce = ["toaster","wifi","bank","ai","light","socialMedia"]


var emptyGrid = Array()

signal gridUpdated(x,y)

func _ready():
	RadioDiffusion.connect("gridUpdateNeeded",gridUpdate)
	RadioDiffusion.connect("recalculateEffectNeeded",recalculateEffect)
	RadioDiffusion.connect("calculateRessourcesNeeded",calculateRessources)
	RadioDiffusion.connect("generateOutcomeNeeded",generateOutcome)
	fillInitialGrid()
	calculateRessources()

func unApplyPatterns(i,j):
	var aPatterns = self.getCell(i,j).appliedPatterns.duplicate(true)
	for pattern in aPatterns:
		for k in range(0,len(pattern.coords)):
			var cell = self.getCell(pattern.coords[k][0],pattern.coords[k][1])
			cell.unApplyPattern(pattern)
			cell.updateSprite()

func getNeighbors(i,j): # North, East, South, West
	return [self.getCell(i-1,j),self.getCell(i,j+1),self.getCell(i+1,j),self.getCell(i,j-1)]

func getNeighborsCoords(i,j): # North, East, South, West
	return [[i-1,j],[i,j+1],[i+1,j],[i,j-1]]

func getCell(i,j): # i = line number and j = column number
	if i >= self.Ymax or j >= self.Xmax or i < 0 or j < 0:
		return self
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
	#await get_tree().create_timer(0.3).timeout
	var newBuilding = popBuilding(type,x,y)
	grid[x][y] = newBuilding
	sourceEffectGrid[x][y] = self.grid[x][y].effect
	if grid[x][y].destroyable : await grid[x][y].get_node("AnimationPlayerBuilding").animation_finished
	recalculateEffect()
	calculateRessources()
	RadioDiffusion.cleanSelectedCall()
	gridUpdated.emit(x,y)
	updateUITooltip()
	checkEndGame()
	
func popBuilding(type,x,y):
	var b = building[type].instantiate()
	b.global_position = Vector2(x*tileSize,y*tileSize)
	b.i = x
	b.j = y
	b.connect("buildingDestruction",unApplyPatterns)
	add_child(b)
	return b

func calculateRessources(): # GB : could be optimized by considering only modified cells
	var recalculatedRessource = {"WATER" : 0,"FOOD" : 0,"O2" : 0}
	var recalculatedHighTechRessource = {"WATER" : 0,"FOOD" : 0,"O2" : 0}
	for i in range(0,self.Ymax):
		for j in range(0,self.Xmax):
			for n in recalculatedRessource.keys():
				var build = self.getCell(i,j)
				build.getTotalStat()
				recalculatedRessource[n] += build.totalStat[n]
				if build.isHighTech :
					recalculatedHighTechRessource[n] += build.totalStat[n]
	GameState.fillRessource(recalculatedRessource)
	GameState.fillHighTechRessource(recalculatedHighTechRessource)
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

func updateUITooltip():
	for n in get_children():
		n.updateTooltip()

func cleanNode():
	for n in get_children():
		n.queue_free()
		
func checkEndGame():
	var NbHighTech = Xmax*Ymax
	for n in get_children():
		if not n.isHighTech : NbHighTech -= 1
	if NbHighTech==0 :
		RadioDiffusion.nextDialogNeeded("EndGame")
		endGameDetected = true
		RadioDiffusion.endGameCall()

func generateOutcome(destr_i,destr_j):
	var outcome = Array()
	for o in possibleOutcomes.keys():
		for p in possibleOutcomes[o]:
			outcome.append(o)
	outcome.shuffle()
	var ok = false
	var nbAttempt = 0
	var nbAttemptMax = 10
	match outcome[0]:
		"LOCK":
			while not ok :
				nbAttempt += 1
				if nbAttempt==nbAttemptMax: 
					generateOutcome(destr_i,destr_j)
					return
				var i = getRandomI()
				var j = getRandomJ()
				if grid[i][j].hasHourglass == false and grid[i][j].lockable: 
					SoundManager.playSoundNamed("lock")
					grid[i][j].setLock()
					RadioDiffusion.nextDialogNeeded("lock")
					ok=true
		"SWAP":
			while not ok:
				nbAttempt += 1
				if nbAttempt==nbAttemptMax: 
					generateOutcome(destr_i,destr_j)
					return
				var i = getRandomI()
				var j = getRandomJ()
				var k = getRandomI()
				var l = getRandomJ()
				if [i,j]!=[k,l] and grid[i][j].swapable and grid[k][l].swapable:
					if [i,j]!=[destr_i,destr_j] and [k,l]!=[destr_i,destr_j]:
						SoundManager.playSoundNamed("swap")
						grid[i][j].swap(k,l,tileSize)
						grid[k][l].swap(i,j,tileSize)
						var bufferIJ = grid[i][j]
						var bufferKL = grid[k][l]
						grid[i][j].i = k
						grid[i][j].j = l
						grid[k][l].i = i
						grid[k][l].j = j
						grid[i][j] = bufferKL
						grid[k][l] = bufferIJ
						bufferIJ = sourceEffectGrid[i][j]
						bufferKL = sourceEffectGrid[k][l]
						sourceEffectGrid[i][j] = bufferKL
						sourceEffectGrid[k][l] = bufferIJ
						recalculateEffect()
						calculateRessources()
						RadioDiffusion.nextDialogNeeded("swap")
						ok = true
		"TIMER":
			while not ok:
				nbAttempt += 1
				if nbAttempt==nbAttemptMax: 
					generateOutcome(destr_i,destr_j)
					return
				var i = getRandomI()
				var j = getRandomJ()
				if grid[i][j].hasHourglass and [i,j]!=[destr_i,destr_j]: 
					SoundManager.playSoundNamed("timer")
					grid[i][j].get_node("Hourglass").decreaseTimer()
					grid[i][j].popLabel("-1 TURN")
					RadioDiffusion.nextDialogNeeded("wait_turn")
					ok=true
		_ : 
			outcomeDialogueRAS.shuffle()
			var outcomeDialogue = outcomeDialogueRAS[0]
			if outcomeDialogue in outComeOnce: outcomeDialogueRAS.erase(outcomeDialogue)
			RadioDiffusion.nextDialogNeeded(outcomeDialogue)
	updateUITooltip()

func getRandomI():
	return randi_range(0,Xmax-1)
func getRandomJ():
	return randi_range(0,Ymax-1)
