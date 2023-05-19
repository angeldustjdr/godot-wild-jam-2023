extends Node

@export var ressourceType:String
@onready var juicyLabel = preload("res://scene/JuicyLabel.tscn")
var myValue = 0

func _ready():
	$Name.text = ressourceType

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
	checkcolor()

func checkcolor():
	pass
