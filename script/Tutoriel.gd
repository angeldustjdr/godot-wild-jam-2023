extends Node2D

func _ready():
	MusicManager.playMusicNamed("game")
	RadioDiffusion.connect("endDialogue",endDialogue)

func _on_skip_button_pressed():
	#SoundManager.playSoundNamed("transition")
	$Rideau/AnimationPlayer.play("rideau_out")
	await $Rideau/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://Main.tscn")

func endDialogue():
	$SkipButton.text = "Play"
