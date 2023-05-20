extends Button


func _ready():
	RadioDiffusion.connect("endGame",endGame)

func endGame():
	self.visible = false



