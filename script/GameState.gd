extends Node

#################
# GLOBAL
var actionnable = true
func actionnable_on():
	actionnable = true
func actionnable_off():
	actionnable = false
	
signal transfertNbAction
var nbAction = 0
var checkPop = false
func increaseNbAction():
	nbAction = (nbAction+1)%2
	transfertNbAction.emit()
	if nbAction==0: 
		checkPop = true
		calculatePop()
	else: checkPop = false

#################
# RESSOURCE
var maxStat = 30
var maxStatPop = 1000
var limit = {"WATER" : 15,"FOOD" : 15,"O2" : 15}
var ressource = {"POP" : 0,
				"WATER" : 0,
				"FOOD" : 0,
				"O2" : 0}
var ressourceHighTech = {"POP" : 0,
				"WATER" : 0,
				"FOOD" : 0,
				"O2" : 0}
var ressourceName = ressource.keys()

func ressourceInit(p,w,f,o):
	ressource = {"POP" : p,
				"WATER" : w,
				"FOOD" : f,
				"O2" : o}

func fillRessource(newRessource):
	for elem in newRessource.keys():
		ressource[elem] = newRessource[elem]
		
func fillHighTechRessource(newRessource):
	for elem in newRessource.keys():
		ressourceHighTech[elem] = newRessource[elem]		

signal GameOver
func calculatePop():
	for elem in limit.keys():
		if ressource[elem] <= limit[elem]:
			ressource["POP"] = clamp(ressource["POP"]-100,0,maxStatPop)
			checkPop = false
	if ressource["POP"] <= 0:
		GameOver.emit()
#########
func reset():
	ressource = {"POP" : 0,
				"WATER" : 0,
				"FOOD" : 0,
				"O2" : 0}
	ressourceHighTech = {"POP" : 0,
				"WATER" : 0,
				"FOOD" : 0,
				"O2" : 0}
	nbAction = 0
	checkPop = false
	actionnable = true

func _ready():
	reset()
