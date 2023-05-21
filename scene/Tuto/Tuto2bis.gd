extends Control


func _ready():
	$Area2D.connect("tutoWell",tutowell)
	RadioDiffusion.connect("endDialogue",endDialogue)

func tutowell():
	$JaugeWater/ArrowWater.visible = true
	$JaugeWater/Jauge_lowtech.visible = true
	$Explanation3.visible = true

func endDialogue():
	$ControlFactory.visible = false
	$ControlRight.visible = true
	$Area2D.visible=true
	$Explanation3.visible = true
	$JaugeWater.visible = true
