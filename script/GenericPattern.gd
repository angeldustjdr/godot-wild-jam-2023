extends Node2D
class_name GenericPattern

var coords = []
var sprites = []

func _ready():
	self.visible = false

func check(_i,_j,_grid):
	self.coords = []
	
func apply(grid):
	for coordinates in self.coords:
		var cell = grid.getCell(coordinates[0],coordinates[1])
		cell.applyPattern(self)
		cell.updateSprite()
