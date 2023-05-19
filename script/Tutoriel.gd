extends Node2D

func _ready():
	var dialogueBox = $Bottom_UI/DialogueText
	dialogueBox.connect("endDialogue",endDialogue)

func _on_skip_button_pressed():
	get_tree().change_scene_to_file("res://Main.tscn")

func endDialogue():
	$SkipButton.text = "Play"
