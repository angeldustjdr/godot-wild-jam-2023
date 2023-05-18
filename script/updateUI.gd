extends ProgressBar

@export var ressourceType:String
@onready var juicyLabel = load("res://scene/JuicyLabel.tscn")

func _ready():
	match ressourceType:
		"POP":self.max_value = GameState.maxStatPop
		_: self.max_value = GameState.maxStat
	RadioDiffusion.connect("updateTopUINeeded",updateTopUI)
	updateTopUI()

func updateTopUI():
	var myRessource = GameState.ressource[ressourceType]
	var modified = 100*(myRessource - self.value)/self.max_value
	self.value = myRessource
	if modified != 0 :
		var j = juicyLabel.instantiate()
		if modified>0 : j.text = "+"+str(int(modified))+"% "+ressourceType
		else : j.text = str(int(modified))+"% "+ressourceType
		add_child(j)
		j.playAnimation("DOWN")
	checkcolor()

func checkcolor():
		if self.value <= self.max_value/2 : 
			self.set("theme_override_colors/font_color", Color(1,0,0))
		else :
			self.set("theme_override_colors/font_color", Color(1,1,1))
