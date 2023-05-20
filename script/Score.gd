extends Label

func _ready():
	RadioDiffusion.connect("endGame",endGame)

func endGame():
	self.visible = true
	var myScore = (GameState.ressource["FOOD"]+GameState.ressource["WATER"]+GameState.ressource["O2"])*GameState.ressource["POP"]
	self.text = "Score: "+str(myScore)+" pts"

