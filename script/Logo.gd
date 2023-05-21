extends Control

var nombre_de_coup_de_casserole = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	#await $Rideau/AnimationPlayer.animation_finished
	await get_tree().create_timer(0.2).timeout 
	for i in range(0,nombre_de_coup_de_casserole):
		$Sprite2D/AnimationPlayer.play("ping")
		await get_tree().create_timer(0.1).timeout 
		SoundManager.playSoundNamed("casserole_one_hit")
		await $Sprite2D/AnimationPlayer.animation_finished
	await get_tree().create_timer(0.2).timeout 
	$Rideau/AnimationPlayer.play("rideau_out")
	await $Rideau/AnimationPlayer.animation_finished
	#SoundManager.playSoundNamed("transition")
	get_tree().change_scene_to_file("res://TitleScene.tscn")
