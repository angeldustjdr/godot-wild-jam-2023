extends ColorRect

func _ready():
	RadioDiffusion.connect("endGame",endGame)

func endGame():
	self.visible = true
	var myScore = (GameState.ressource["FOOD"]+GameState.ressource["WATER"]+GameState.ressource["O2"])*GameState.ressource["POP"]
	$Score.text = "Score: "+str(myScore)+" pts"

