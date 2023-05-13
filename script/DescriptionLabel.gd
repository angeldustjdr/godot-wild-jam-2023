extends Label

@onready var shown = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shown:
		self.visible = true
		self.set_global_position(get_global_mouse_position())
	else :
		self.visible = false
