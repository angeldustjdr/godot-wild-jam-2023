extends Node

#################
# GLOBAL
var actionnable = true
func actionnable_on():
	actionnable = true
func actionnable_off():
	actionnable = false

#################
# RESSOURCE
var ressource = {"POP" : 1000,
				"WATER" : 0,
				"FOOD" : 0,
				"O2" : 0}
var ressourceName = ressource.keys()

func fillRessource(newRessource):
	ressource = newRessource
