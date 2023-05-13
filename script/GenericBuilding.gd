extends Area2D
class_name GenericBuilding

@export var description:String
var i
var j

# Called when the node enters the scene tree for the first time.
func _ready():
	$Tooltip.tooltip_text = description

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_LEFT:
			selfDestruct()

func selfDestruct():
	print(i,j)
	GameState.grid[i][j] = "Empty"
	GameState.callUpdateGrid()
