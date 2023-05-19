extends Node2D
class_name GenericPattern

var coords = []
var sprites = []

func _ready():
	self.visible = false

func check(_i,_j,_grid):
	self.coords = []

func apply(_grid):
	pass
