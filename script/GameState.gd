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
	if nbAction==0: checkPop = true
	else: checkPop = false

#################
# RESSOURCE
var limit = {"WATER" : 10,"FOOD" : 10,"O2" : 10}
var ressource = {"POP" : 0,
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

func calculatePop():
	for elem in limit.keys():
		if ressource[elem] <= limit[elem]:
			ressource["POP"] -= 100
			checkPop = false
