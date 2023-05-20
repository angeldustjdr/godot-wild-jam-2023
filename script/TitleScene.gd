extends Node2D

func _ready():
	GameState.reset()



func _on_start_button_pressed():
	$Rideau/AnimationPlayer.play("rideau_out")
	await $Rideau/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scene/Tutoriel.tscn")
