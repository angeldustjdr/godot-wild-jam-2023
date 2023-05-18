extends GenericPattern
class_name IrrigatedPattern

var coords_well = [] # self.coords is used for farm coordinates

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	self.sprites = {"irrigated_crops": preload('res://asset/sheet/crops_irrigated.png'),
					"irrigated_well": preload('res://asset/sheet/irrigated_well.png')}
		
func check(i,j,grid):
	self.coords = []
	self.coords_well = []
	var cellij = grid.getCell(i,j)
	if(cellij != null):
		var neighbors_coords = grid.getNeighborsCoords(i,j)
		if cellij is Farm:
			self.coords.append([i,j])
			for coordinates in neighbors_coords:
				var cell = grid.getCell(coordinates[0],coordinates[1])
				if cell is Well and not cell.isPatternApplied(self):
					self.coords_well.append([coordinates[0],coordinates[1]])
					return true
			return false
		elif cellij is Well:
			self.coords_well.append([i,j])
			for coordinates in neighbors_coords:
				var cell = grid.getCell(coordinates[0],coordinates[1])
				if cell is Farm and not cell.isPatternApplied(self):
					print(self.coords)
					self.coords.append([coordinates[0],coordinates[1]])
					return true
			return false
		else:
			return false

func apply(grid):
	for coordinates in self.coords:
		var cell = grid.getCell(coordinates[0],coordinates[1])
		cell.get_node("Sprite").texture = self.sprites["irrigated_crops"]
		cell.applyPattern(self)
	for coordinates in self.coords_well:
		var cell = grid.getCell(coordinates[0],coordinates[1])
		cell.get_node("Sprite").texture = self.sprites["irrigated_well"]
		cell.applyPattern(self)
	self.coords = []
	self.coords_well = []
		
		
