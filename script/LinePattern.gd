extends GenericPattern
class_name LinePattern

var name_to_check = "GenericBuilding"
var orientation = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	super()

func checkLine(grid,line):
	for coordinates in line:
		var cell = grid.getCell(coordinates[0],coordinates[1])
		if ((not name_to_check in cell.name)
			or (cell.isPatternAppliedName(self.name))):
			return false
	return true

func check(i,j,grid):
	super(i,j,grid)
	var possibleLines = [[[i-1,j],[i,j],[i+1,j]], #Vertical
						[[i-2,j],[i-1,j],[i,j]], #Vertical
						[[i,j],[i+1,j],[i+2,j]], #Vertical
						[[i,j-1],[i,j],[i,j+1]], #Horizontal
						[[i,j-2],[i,j-1],[i,j]], #Horizontal
						[[i,j],[i,j+1],[i,j+2]]] #Horizontal
	for k in range(0,len(possibleLines)):
		var line = possibleLines[k]
		if checkLine(grid,line):
			self.coords = line
			if k < 3 :
				self.orientation = 90
			else:
				self.orientation = 0
			return true
	return false

func apply(grid):
	for k in range(0,len(self.coords)):
		var coordinates = self.coords[k] 
		var cell = grid.getCell(coordinates[0],coordinates[1])
		cell.applyPattern(self,k,self.orientation)
		cell.updateSprite()
