extends Node

var testVar:int = 3

var grid:Array

func setGrid(x,y,type):
	grid[x][y] = type

func setFullGrid(myGrid):
	grid = myGrid
	
func getCell(i,j):
	return grid[i][j]
