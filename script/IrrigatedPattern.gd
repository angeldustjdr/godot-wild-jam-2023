extends NextToPattern
class_name IrrigatedPattern

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	self.name_building_1 = "Farm" # name of first building of the pattern
	self.name_building_2 = "Well" # name of second building of the pattern
