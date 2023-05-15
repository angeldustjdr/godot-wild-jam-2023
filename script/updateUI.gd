extends Label

@export var ressourceType:String
@onready var juicyLabel = load("res://scene/JuicyLabel.tscn")

func _ready():
	RadioDiffusion.connect("updateTopUINeeded",updateTopUI)

func updateTopUI():
	var modified = GameState.ressource[ressourceType] - int(self.text)
	self.text = str(GameState.ressource[ressourceType])
	if modified != 0 :
		var j = juicyLabel.instantiate()
		if modified>0 : j.text = "+"+str(modified)+ressourceType
		else : j.text = str(modified)+ressourceType
		j.playAnimation("DOWN")
		add_child(j)
