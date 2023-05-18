extends FourPattern
class_name FourFieldsPattern

func _ready():
	super()
	self.name_to_check = "Farm"
	self.sprites = [preload('res://asset/sheet/big_farm_upper_left.png'),
					preload('res://asset/sheet/big_farm_upper_right.png'),
					preload('res://asset/sheet/big_farm_lower_right.png'),
					preload('res://asset/sheet/big_farm_lower_left.png')] # 1 : upper left, 2 upper right, 3 lower right, 4 lower left
