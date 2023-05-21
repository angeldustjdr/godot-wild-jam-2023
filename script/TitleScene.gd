extends Node2D

func _ready():
	GameState.reset()



func _on_start_button_pressed():
	#SoundManager.playSoundNamed("transition")
	$Rideau/AnimationPlayer.play("rideau_out")
	await $Rideau/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scene/Tutoriel.tscn")


func _on_credit_button_pressed():
	#SoundManager.playSoundNamed("transition")
	$Rideau/AnimationPlayer.play("rideau_out")
	await $Rideau/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scene/Credits.tscn")
