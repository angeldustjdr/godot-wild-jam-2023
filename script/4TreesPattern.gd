extends FourPattern
class_name FourTreesPattern

func _ready():
	super()
	self.name_to_check = "Tree"
	self.sprites = [preload('res://asset/sheet/big_tree_upper_left.png'),
					preload('res://asset/sheet/big_tree_upper_right.png'),
					preload('res://asset/sheet/big_tree_lower_right.png'),
					preload('res://asset/sheet/big_tree_lower_left.png')] # 1 : upper left, 2 upper right, 3 lower right, 4 lower left
