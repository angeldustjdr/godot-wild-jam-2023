extends Area2D
class_name GenericBuilding

@export_multiline var description:String
@export var playIdle:bool

@export var base_stat = {"POP" : 0,
				"WATER" : 0,
				"FOOD" : 0,
				"O2" : 0}
@export var modifier = {"POP" : 0,
				"WATER" : 0,
				"FOOD" : 0,
				"O2" : 0}

var i
var j
@onready var juicyLabel = load("res://scene/JuicyLabel.tscn")

func _ready():
	if playIdle: 
		$AnimationPlayerBuilding.speed_scale = randf_range(0.9,1.1)
		$AnimationPlayerBuilding.play("idle")
	RadioDiffusion.connect("updateTopUINeeded",updateTooltip)
	updateTooltip()
	var totStat = getTotalStat()
	if totStat != null: popLabel(totStat)


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and GameState.actionnable:
		if event.button_index==MOUSE_BUTTON_LEFT:
			GameState.actionnable_off()
			selfDestruct("Empty")

func selfDestruct(type):
	#print(i,j)
	RadioDiffusion.gridUpdateCall(i,j,type)
	await get_tree().create_timer(0.3).timeout #A remplacer par l'animation de destruction
	GameState.actionnable_on()
	GameState.increaseNbAction()
	RadioDiffusion.cleanSelectedCall()
	queue_free()

func updateTooltip():
	var updatedDescription = description
	updatedDescription += getTotalStat()
	$Tooltip.tooltip_text = updatedDescription

func getTotalStat():
	var TotalStat = ""
	for n in GameState.ressourceName:
		if base_stat[n]!=0 or modifier[n]!=0 :
			var totalStat = base_stat[n]+modifier[n]
			var plus = ""
			if totalStat>0: plus="+" 
			TotalStat += "\n"+plus+str(totalStat)+" "+n
	return TotalStat

func popLabel(text):
	var l = juicyLabel.instantiate()
	l.playAnimation("UP")
	l.text = text
	add_child(l)


func _on_tooltip_mouse_entered():
	$Sprite.material.set("shader_param/width",2.)


func _on_tooltip_mouse_exited():
	$Sprite.material.set("shader_param/width",0.)
