extends Area2D
class_name GenericBuilding

@export var description:String
var i
var j
var isActionable = true
@onready var grid = self.get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Tooltip.tooltip_text = description

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and isActionable == true:
		if event.button_index==MOUSE_BUTTON_LEFT:
			isActionable = false
			selfDestruct()

func selfDestruct():
	print(i,j)
	grid.gridUpdate(i,j,"Empty")
	queue_free()
