extends Node2D

var tileSize:int = 68 # in pixel
var Xmax:int = 6
var Ymax:int = 5
var grid:Array # hold the data of the grid

@onready var building = load("res://scene/GenericBuilding.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	fillGrid()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fillGrid() -> void:
	for j in Ymax:
		var col = Array()
		for i in Xmax:
			var b = building.instantiate()
			b.global_position = Vector2(i*tileSize,j*tileSize)
			add_child(b)
			col.append("Generic")
		grid.append(col)
	
	
