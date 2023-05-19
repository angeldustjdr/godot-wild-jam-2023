extends Node

@export var ressourceType:String
@onready var juicyLabel = preload("res://scene/JuicyLabel.tscn")
@onready var iconTexture = {"FOOD" : "res://asset/sprite/icon_food.png","WATER":"res://asset/sprite/icon_water.png","O2":"res://asset/sprite/icon_o2.png"}
@onready var jaugeTexture1 = {"FOOD" : "res://asset/sprite/jauge_food1.png","WATER":"res://asset/sprite/jauge_water1.png","O2":"res://asset/sprite/jauge_o1.png"}
@onready var jaugeTexture2 = {"FOOD" : "res://asset/sprite/jauge_food2.png","WATER":"res://asset/sprite/jauge_water2.png","O2":"res://asset/sprite/jauge_o2.png"}
var total = 0
var hightech = 0
var lowtech = 0

func _ready():
	$Name.text = ressourceType
	$Icon.texture = load(iconTexture[ressourceType])
	$Jauge_lowtech.texture = load(jaugeTexture1[ressourceType])
	$Jauge_hightech.texture = load(jaugeTexture2[ressourceType])
	RadioDiffusion.connect("updateTopUINeeded",updateTopUI)
	total = GameState.ressource[ressourceType]
	hightech = GameState.ressourceHighTech[ressourceType]
	lowtech = total - hightech

func updateTopUI():
	var newTotal = GameState.ressource[ressourceType]
	var newHighTechTotal = GameState.ressourceHighTech[ressourceType]
	var newLowTechTotal = newTotal - newHighTechTotal
	var modified = toPourcent(newTotal - total)
	if modified!=0:
		var mySign = ""
		if modified>0 : mySign="+"
		RadioDiffusion.popLabelCall(self.global_position+Vector2(34,34),mySign+str(modified)+"% "+ressourceType,"DOWN")
	total = newTotal
	hightech = newHighTechTotal
	lowtech = newLowTechTotal
	self.tooltip_text = str(toPourcent(hightech))+"% (high tech)\n"+str(toPourcent(lowtech))+"% (low tech)"
	$Jauge_lowtech.scale.x = 2.*clamp(toPourcent(lowtech),0,100)/100.
	$Jauge_hightech.scale.x = 2.*clamp(toPourcent(hightech),0,100-clamp(toPourcent(lowtech),0,100))/100.
	$Jauge_hightech.position.x = $Jauge_lowtech.position.x + $Jauge_lowtech.texture.get_width()*$Jauge_lowtech.scale.x
	$Amount.text = str(clamp(toPourcent(total),0,100))+"%"
	checkColor()

func checkColor():
	if clamp(toPourcent(total),0,100) < 50 : 
		if not $Amount/AnimationPlayer.is_playing() : $Amount/AnimationPlayer.play("flash")
	else : $Amount/AnimationPlayer.play("RESET")
	
func toPourcent(nb):
	return 100.*nb/(GameState.maxStat/2.)
