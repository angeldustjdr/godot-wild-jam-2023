extends Node2D

var tileSize:int = 68 # in pixel
var Xmax:int = 6
var Ymax:int = 5

var building = {"Generic" : load("res://scene/GenericBuilding.tscn"),
				"Empty" : load("res://scene/Empty.tscn") }

# Called when the node enters the scene tree for the first time.
func _ready():
	fillGrid()
	GameState.connect("gridUpdateNeeded",_on_gridUpdateNeeded)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fillGrid() -> void:
	for i in Xmax:
		var col = Array()
		for j in Ymax:
			popBuilding("Generic",i,j)
			col.append("Generic")
		GameState.grid.append(col)
	print(GameState.grid)

func _on_gridUpdateNeeded():
	cleanNode()
	for i in Xmax:
		for j in Ymax:
			popBuilding(GameState.grid[i][j],i,j)
	
func popBuilding(type,x,y):
	var b = building[type].instantiate()
	b.global_position = Vector2(x*tileSize,y*tileSize)
	b.i = x
	b.j = y
	add_child(b)

func cleanNode():
	for n in get_children():
		n.queue_free()
