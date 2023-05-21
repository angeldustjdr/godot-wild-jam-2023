extends GenericPattern
class_name NextToPattern

var name_building_1 = "GenericBuilding" # name of first building of the pattern
var name_building_2 = "GenericBuilding" # name of second building of the pattern

# Called when the node enters the scene tree for the first time.
func _ready():
	super()

func check(i,j,grid):
	super(i,j,grid)
	var cellij = grid.getCell(i,j)
	if(cellij != null):
		var neighbors_coords = grid.getNeighborsCoords(i,j)
		if self.name_building_1 in cellij.name:
			self.coords.append([i,j])
			for coordinates in neighbors_coords:
				var cell = grid.getCell(coordinates[0],coordinates[1])
				if self.name_building_2 in cell.name and not cell.isPatternAppliedName(self.name):
					self.coords.append([coordinates[0],coordinates[1]])
					#print(self.coords)
					return true
			return false
		elif self.name_building_2 in cellij.name:
			self.coords.append([i,j])
			for coordinates in neighbors_coords:
				var cell = grid.getCell(coordinates[0],coordinates[1])
				if self.name_building_1 in cell.name and not cell.isPatternAppliedName(self.name):
					self.coords.append([coordinates[0],coordinates[1]])
					#print(self.coords)
					return true
			return false
		else:
			return false
