extends Label

var myValue

func _ready():
	RadioDiffusion.connect("updateTopUINeeded",updateTopUI)
	myValue = GameState.ressource["POP"]
	self.text = str(myValue)

func updateTopUI():
	var modified = GameState.ressource["POP"] - myValue
	if modified != 0 :
		var mySign = ""
		if modified>0 : mySign="+"
		RadioDiffusion.popLabelCall(self.global_position+Vector2(34,34),mySign+str(modified)+" POP","DOWN")
	myValue = GameState.ressource["POP"]
	self.text = str(myValue)
