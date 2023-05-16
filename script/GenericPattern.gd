extends Node2D
class_name GenericPattern

var coords = []

func _ready():
	self.visible = false

func apply(_grid):
	pass

func completeSquareCoords():
	if len(self.coords) > 1:
		print("GenericPattern:completeSquareCoords:ERROR: more than one couple of coordinates before completing.")
		return -1
	var i = self.coords[0][0]
	var j = self.coords[0][1]
	self.coords.append([i,j+1])
	self.coords.append([i+1,j+1])
	self.coords.append([i+1,j])
	return 0

func check(_i,_j,_grid):
	pass
