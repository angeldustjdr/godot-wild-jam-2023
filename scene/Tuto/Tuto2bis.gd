extends Control


func _ready():
	$Area2D.connect("tutoWell",tutowell)
	RadioDiffusion.connect("endDialogue",endDialogue)
	RadioDiffusion.connect("startCurrentDialogue",startCurrentDialogue)

func tutowell():
	$JaugeWater/ArrowWater.visible = true
	$JaugeWater/Jauge_lowtech.visible = true
	$Explanation3.visible = true

func startCurrentDialogue(tag):
	if tag=="tuto7":
		$ControlFactory.visible = false
		$Area2D.visible=true
		$Explanation3.visible = true
		$JaugeWater.visible = true

func endDialogue():
	$ControlRight.visible = true

