extends GenericPattern

var sprites = [preload('res://asset/sheet/upper_left.png'),
			preload('res://asset/sheet/upper_right.png'),
			preload('res://asset/sheet/lower_right.png'),
			preload('res://asset/sheet/lower_left.png')] # 1 : upper left, 2 upper right, 3 lower right, 4 lower left

var list_coords = [] # 1 : upper left, 2 upper right, 3 lower right, 4 lower left

# Called when the node enters the scene tree for the first time.

func completeCoords():
	if len(self.list_coords) > 1:
		print("4FieldsPattern:completeCoords:ERROR: more than one couple of coordinates before completing.")
		return -1
	var i = self.list_coords[0][0]
	var j = self.list_coords[0][1]
	self.list_coords.append([i,j+1])
	self.list_coords.append([i+1,j+1])
	self.list_coords.append([i+1,j])
	return 0
	
func check(i,j):
	var cellij = self.getCell(i,j)
	if(cellij != null):
		if cellij is Farm:
			var cellip1j = self.getCell(i+1,j)
			if cellip1j is Farm:
				var cellijp1 = self.getCell(i,j+1)
				if cellijp1 is Farm:
					var cellip1jp1 = self.getCell(i+1,j+1)
					if cellip1jp1 is Farm:
						self.list_coords.append([i,j])
						self.completeCoords()
						return true
					else:
						return false
				else:
					var cellijm1 = self.getCell(i,j-1)
					if cellijm1 is Farm:
						var cellip1jm1 = self.getCell(i+1,j-1)
						if cellip1jm1 is Farm:
							self.list_coords.append([i,j-1])
							self.completeCoords()
							return true
						else:
							return false
					else:
						return false
			else:
				var cellim1j = self.getCell(i-1,j)
				if cellim1j is Farm:
					var cellijp1 = self.getCell(i,j+1)
					if cellijp1 is Farm:
						var cellim1jp1 = self.getCell(i-1,j+1)
						if cellim1jp1 is Farm:
							self.list_coords.append([i-1,j])
							self.completeCoords()
							return true
						else:
							return false
					else:
						var cellijm1 = self.getCell(i,j-1)
						if cellijm1 is Farm:
							var cellim1jm1 = self.getCell(i-1,j-1)
							if cellim1jm1 is Farm:
								self.list_coords.append([i-1,j-1])
								self.completeCoords()
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
		print("4FieldsPattern:check:cell(i,j) is empty???")
		return -1
	
func apply():
	for i in range(0,len(self.list_coords)):
		var row = self.list_coords[i][0]
		var col = self.list_coords[i][1]
		self.getCell(row,col).get_node("Sprite").texture = self.sprites[i]
	self.list_coords=[]

func _ready():
	super()
