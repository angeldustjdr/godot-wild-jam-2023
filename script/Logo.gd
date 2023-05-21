extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	SoundManager.playSoundNamed("casserole")
	await get_tree().create_timer(2.0).timeout
	$Rideau.actionRideau("out")
	#SoundManager.playSoundNamed("transition")
	get_tree().change_scene_to_file("res://TitleScene.tscn")
