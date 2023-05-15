extends Label

@export var ressourceType:String
@onready var juicyLabel = load("res://scene/JuicyLabel.tscn")

func _ready():
	RadioDiffusion.connect("updateTopUINeeded",updateTopUI)
	updateTopUI()

func updateTopUI():
	var myRessource = GameState.ressource[ressourceType]
	var modified = myRessource - int(self.text)
	self.text = str(myRessource)
	if modified != 0 :
		var j = juicyLabel.instantiate()
		if modified>0 : j.text = "+"+str(modified)+ressourceType
		else : j.text = str(modified)+ressourceType
		j.playAnimation("DOWN")
		add_child(j)
	checkcolor()

func checkcolor():
	var myRessource = GameState.ressource[ressourceType]
	if ressourceType!="POP":
		if myRessource <= GameState.limit[ressourceType] : 
			self.set("theme_override_colors/font_color", Color(1,0,0))
		else :
			self.set("theme_override_colors/font_color", Color(1,1,1))
