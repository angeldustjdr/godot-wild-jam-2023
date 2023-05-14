extends Node

#################
# GLOBAL
var actionnable = true
func actionnable_on():
	actionnable = true
func actionnable_off():
	actionnable = false

#################
# GRID 
var grid:Array
var Xmax:int = 6
var Ymax:int = 5

func setGrid(x,y,type):
	grid[x][y] = type
	#print(grid)

func setFullGrid(myGrid):
	grid = myGrid
	
func getCell(i,j):
	return grid[i][j]

#################
# RESSOURCE
var ressource = {"POP" : 1000,
				"WATER" : 0,
				"FOOD" : 0,
				"O2" : 0}
var ressourceName = ressource.keys()

func fillRessource(newRessource):
	ressource = newRessource
