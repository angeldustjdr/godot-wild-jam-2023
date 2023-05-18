extends Node

@export var ressourceType:String
@onready var juicyLabel = preload("res://scene/JuicyLabel.tscn")
var myValue = 0
var maxValue 

func _ready():
	match ressourceType:
		"POP": maxValue = GameState.maxStatPop
	RadioDiffusion.connect("updateTopUINeeded",updateTopUI)
	updateTopUI()

func updateTopUI():
	var myRessource = GameState.ressource[ressourceType]
	var modified
	if ressourceType=="POP": 
		modified = myRessource-myValue
		myValue = myRessource
		self.text = str(myValue)
		if modified!=0 : RadioDiffusion.popLabelCall(self.global_position+Vector2(34,34),str(modified),"DOWN")
	else : 
		modified = 100*(myRessource - self.value)/self.max_value
		self.value = myRessource
#	if modified != 0 :
#		var j = juicyLabel.instantiate()
#		if ressourceType == "POP" :
#			if modified>0 : j.text = "+"+str(modified)+" "+ressourceType
#			else : j.text = str(modified)+" "+ressourceType
#		else :
#			if modified>0 : j.text = "+"+str(int(modified))+"% "+ressourceType
#			else : j.text = str(int(modified))+"% "+ressourceType
#		add_child(j)
#		j.playAnimation("DOWN")
	checkcolor()

func checkcolor():
	if ressourceType == "POP" :
		if myValue <= maxValue/2 : 
			self.set("theme_override_colors/font_color", Color(1,0,0))
		else :
			self.set("theme_override_colors/font_color", Color(1,1,1))
	else :
		if self.value <= self.max_value : 
			self.set("theme_override_colors/font_color", Color(1,0,0))
		else :
			self.set("theme_override_colors/font_color", Color(1,1,1))
