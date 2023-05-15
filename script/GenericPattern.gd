extends Node2D
class_name GenericPattern

func getCell(i,j):
	return self.get_parent().get_parent().get_node("Grid").getCell(i,j)

func _ready():
	self.visible = false

func apply():
	pass

func check(_i,_j):
	pass
