extends Label

@export var ressourceType:String

func _ready():
	RadioDiffusion.connect("updateTopUINeeded",updateTopUI)

func updateTopUI():
	self.text = str(GameState.ressource[ressourceType])
