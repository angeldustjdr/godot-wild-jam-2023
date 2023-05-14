extends Area2D
class_name GenericBuilding

@export_multiline var description:String

var i
var j

@export var base_stat = {"POP" : 0,
				"WATER" : 0,
				"FOOD" : 0,
				"O2" : 0}
@export var modifier = {"POP" : 0,
				"WATER" : 0,
				"FOOD" : 0,
				"O2" : 0}

# Called when the node enters the scene tree for the first time.
func _ready():
	RadioDiffusion.connect("updateTopUINeeded",updateTooltip)
	updateTooltip()
	var totStat = getTotalStat()
	if totStat != null:
		$JuicyLabel.text = totStat
		$AnimationPlayer.play("JuicyLabelPop")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and GameState.actionnable:
		if event.button_index==MOUSE_BUTTON_LEFT:
			GameState.actionnable_off()
			selfDestruct("Empty")

func selfDestruct(type):
	#print(i,j)
	RadioDiffusion.gridUpdateCall(i,j,type)
	await get_tree().create_timer(0.3).timeout #A remplacer par l'animation de destruction
	GameState.actionnable_on()
	RadioDiffusion.cleanSelectedCall()
	queue_free()

func updateTooltip():
	var updatedDescription = description
	updatedDescription += getTotalStat()
	$Tooltip.tooltip_text = updatedDescription

func getTotalStat():
	var TotalStat:String
	for name in GameState.ressourceName:
		if base_stat[name]!=0 or modifier[name]!=0 :
			var totalStat = base_stat[name]+modifier[name]
			var sign = ""
			if totalStat>0: sign="+" 
			TotalStat += "\n"+sign+str(totalStat)+" "+name
	return TotalStat
