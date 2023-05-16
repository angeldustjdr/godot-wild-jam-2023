extends Area2D
class_name GenericBuilding

@export_multiline var description:String
@export var effect:String = "Nothing"
@export var playIdle:bool

@export var base_stat = {"POP" : 0,
				"WATER" : 0,
				"FOOD" : 0,
				"O2" : 0}
@export var modifier = {"POP" : 0,
				"WATER" : 0,
				"FOOD" : 0,
				"O2" : 0}
var totalStat = {"POP" : 0,
				"WATER" : 0,
				"FOOD" : 0,
				"O2" : 0}
@export var negativeStat = false
@export var hasHourglass = false
@export var hourglassTimer = 50
@export var effectDescription = {"Heat" : "The air temperature is pretty high here! It may harm life."}

var i
var j
var cellEffect = "Nothing"
@onready var juicyLabel = load("res://scene/JuicyLabel.tscn")

func _ready():
	if hasHourglass:
		var hourglass = load("res://scene/Hourglass.tscn")
		var h = hourglass.instantiate()
		h.setTimer(hourglassTimer)
		add_child(h)
	if playIdle: 
		$AnimationPlayerBuilding.speed_scale = randf_range(0.9,1.1)
		$AnimationPlayerBuilding.play("idle")
	RadioDiffusion.connect("updateTopUINeeded",updateTooltip)
	updateTooltip()


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and GameState.actionnable:
		if event.button_index==MOUSE_BUTTON_LEFT:
			GameState.actionnable_off()
			selfDestruct("Empty")

func selfDestruct(type):
	#print(i,j)
	RadioDiffusion.gridUpdateCall(i,j,type)
	queue_free()

func updateTooltip():
	var updatedDescription = description
	updatedDescription += getTotalStat()
	updatedDescription += getCellEffect()
	$Tooltip.tooltip_text = updatedDescription

func getTotalStat():
	var returnStat = ""
	for n in GameState.ressourceName:
		if negativeStat: totalStat[n] = base_stat[n]+modifier[n]
		else : totalStat[n] = clamp(base_stat[n]+modifier[n],0,100)
		if totalStat[n]!=0:
			var plus = ""
			if totalStat[n]>0: plus="+" 
			returnStat += "\n"+plus+str(totalStat[n])+" "+n
	return returnStat

func getCellEffect():
	var returned = ""
	if cellEffect != "Nothing":
		returned = "\n"+effectDescription[cellEffect]
	return returned

func popLabel(text):
	var l = juicyLabel.instantiate()
	l.playAnimation("UP")
	l.text = text
	add_child(l)

func cleanParticules():
	for n in get_children():
		if n is CPUParticles2D:
			n.queue_free()

func applyCellEffect(myEffect):
	if myEffect!=cellEffect:
		applyEffectModifier(myEffect)
		match myEffect:
			"Heat":
				var particules = load("res://scene/HeatParticules.tscn")
				var p = particules.instantiate()
				add_child(p)
		cellEffect = myEffect
		updateTooltip()

func applyEffectModifier(_effectName):
	pass

func _on_tooltip_mouse_entered():
	$Sprite.material.set_shader_parameter("width",2.)


func _on_tooltip_mouse_exited():
	$Sprite.material.set_shader_parameter("width",0.)
