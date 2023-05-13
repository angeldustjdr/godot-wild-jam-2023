extends Area2D
class_name GenericBuilding

@export var description:String = "A generic building."

# Called when the node enters the scene tree for the first time.
func _ready():
	$Tooltip.tooltip_text = description

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
