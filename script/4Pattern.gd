extends GenericPattern
class_name FourPattern

var name_to_check = "GenericBuilding" #building type to apply the pattern

func _ready():
	super()

func check(i,j,grid):
	super(i,j,grid)
	var cellij = grid.getCell(i,j)
	if(cellij != null):
		if name_to_check in cellij.name:
			var cellip1j = grid.getCell(i+1,j)
			if name_to_check in cellip1j.name:
				var cellijp1 = grid.getCell(i,j+1)
				if name_to_check in cellijp1.name:
					var cellip1jp1 = grid.getCell(i+1,j+1)
					if name_to_check in cellip1jp1.name:
						self.coords.append([i,j])
						self.completeSquareCoords()
						return true
					else:
						return false
				else:
					var cellijm1 = grid.getCell(i,j-1)
					if name_to_check in cellijm1.name:
						var cellip1jm1 = grid.getCell(i+1,j-1)
						if name_to_check in cellip1jm1.name:
							self.coords.append([i,j-1])
							self.completeSquareCoords()
							return true
						else:
							return false
					else:
						return false
			else:
				var cellim1j = grid.getCell(i-1,j)
				if name_to_check in cellim1j.name:
					var cellijp1 = grid.getCell(i,j+1)
					if name_to_check in cellijp1.name:
						var cellim1jp1 = grid.getCell(i-1,j+1)
						if name_to_check in cellim1jp1.name:
							self.coords.append([i-1,j])
							self.completeSquareCoords()
							return true
						else:
							return false
					else:
						var cellijm1 = grid.getCell(i,j-1)
						if name_to_check in cellijm1.name:
							var cellim1jm1 = grid.getCell(i-1,j-1)
							if name_to_check in cellim1jm1.name:
								self.coords.append([i-1,j-1])
								self.completeSquareCoords()
								return true
							else:
								return false
						else:
							return false
				else:
					return false
		else:
			return false
	else:
		print("4Pattern:check:cell(i,j) is empty???")
		return -1

func completeSquareCoords():
	if len(self.coords) > 1:
		print("GenericPattern:completeSquareCoords:ERROR: more than one couple of coordinates before completing.")
		return -1
	var i = self.coords[0][0]
	var j = self.coords[0][1]
	self.coords.append([i,j+1])
	self.coords.append([i+1,j+1])
	self.coords.append([i+1,j])
	return 0

func checkAlreadySquare(grid):
	for coord in self.coords:
		var i = coord[0]
		var j = coord[1]
		if grid.getCell(i,j).isPatternAppliedName(self.name):
			return false
	return true

func apply(grid):
	if self.checkAlreadySquare(grid):
		for i in range(0,len(self.coords)):
			var cell = grid.getCell(self.coords[i][0],self.coords[i][1])
			cell.applyPattern(self,i)
			cell.updateSprite()
