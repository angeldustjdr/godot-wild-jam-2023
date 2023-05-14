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

func setGrid(x,y,type):
	grid[x][y] = type
	print(grid)

func setFullGrid(myGrid):
	grid = myGrid
	
func getCell(i,j):
	return grid[i][j]

#################
# RESSOURCE
var ressource = {"POP" : 1000,
				"WATER" : 12,
				"FOOD" : 12,
				"02" : 12}

func getRessource(type):
	return ressource[type]
