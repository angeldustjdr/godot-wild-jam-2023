extends Node2D

var tileSize:int = 68 # in pixel
var Xmax:int = 6
var Ymax:int = 5

var building = {"Generic" : load("res://scene/GenericBuilding.tscn"),
				"Empty" : load("res://scene/Empty.tscn") }

# Called when the node enters the scene tree for the first time.
func _ready():
	fillGrid()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fillGrid() -> void:
	var myGrid = Array()
	for i in Xmax:
		var col = Array()
		for j in Ymax:
			popBuilding("Generic",i,j)
			col.append("Generic")
		myGrid.append(col)
	GameState.setFullGrid(myGrid)

func gridUpdate(x,y,type):
	GameState.setGrid(x,y,type)
	popBuilding(GameState.getCell(x,y),x,y)
	
func popBuilding(type,x,y):
	var b = building[type].instantiate()
	b.global_position = Vector2(x*tileSize,y*tileSize)
	b.i = x
	b.j = y
	add_child(b)

func cleanNode():
	for n in get_children():
		n.queue_free()
