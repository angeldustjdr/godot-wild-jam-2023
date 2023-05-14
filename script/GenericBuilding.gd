extends Area2D
class_name GenericBuilding

@export var description:String
var i
var j
@onready var grid = self.get_parent()
@onready var main = grid.get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Tooltip.tooltip_text = description

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and GameState.actionnable:
		if event.button_index==MOUSE_BUTTON_LEFT:
			GameState.actionnable_off()
			selfDestruct("Empty")

func selfDestruct(type):
	print(i,j)
	grid.gridUpdate(i,j,type)
	await get_tree().create_timer(0.1).timeout #A remplacer par l'animation de destruction
	GameState.actionnable_on()
	main.cleanSelected()
	queue_free()
