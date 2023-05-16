extends GenericPattern
class_name FourTreesPattern

var sprites = [preload('res://asset/sheet/big_tree_upper_left.png'),
			preload('res://asset/sheet/big_tree_upper_right.png'),
			preload('res://asset/sheet/big_tree_lower_right.png'),
			preload('res://asset/sheet/big_tree_lower_left.png')] # 1 : upper left, 2 upper right, 3 lower right, 4 lower left

func check(i,j,grid):
	var cellij = grid.getCell(i,j)
	if(cellij != null):
		if cellij is myTree:
			var cellip1j = grid.getCell(i+1,j)
			if cellip1j is myTree:
				var cellijp1 = grid.getCell(i,j+1)
				if cellijp1 is myTree:
					var cellip1jp1 = grid.getCell(i+1,j+1)
					if cellip1jp1 is myTree:
						self.coords.append([i,j])
						self.completeSquareCoords()
						return true
					else:
						return false
				else:
					var cellijm1 = grid.getCell(i,j-1)
					if cellijm1 is myTree:
						var cellip1jm1 = grid.getCell(i+1,j-1)
						if cellip1jm1 is myTree:
							self.coords.append([i,j-1])
							self.completeSquareCoords()
							return true
						else:
							return false
					else:
						return false
			else:
				var cellim1j = grid.getCell(i-1,j)
				if cellim1j is myTree:
					var cellijp1 = grid.getCell(i,j+1)
					if cellijp1 is myTree:
						var cellim1jp1 = grid.getCell(i-1,j+1)
						if cellim1jp1 is myTree:
							self.coords.append([i-1,j])
							self.completeSquareCoords()
							return true
						else:
							return false
					else:
						var cellijm1 = grid.getCell(i,j-1)
						if cellijm1 is myTree:
							var cellim1jm1 = grid.getCell(i-1,j-1)
							if cellim1jm1 is myTree:
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
		print("4TreesPattern:check:cell(i,j) is empty???")
		return -1

func checkNotBig(grid):
	for coord in self.coords:
		var i = coord[0]
		var j = coord[1]
		if grid.getCell(i,j).is_big:
			return false
	return true

func apply(grid):
	if self.checkNotBig(grid):
		for i in range(0,len(self.coords)):
			var row = self.coords[i][0]
			var col = self.coords[i][1]
			var cell = grid.getCell(row,col)
			cell.get_node("Sprite").texture = self.sprites[i]
			cell.becomes_big()
			cell.applyPatternModifier(self)
	self.coords=[]

func _ready():
	super()
