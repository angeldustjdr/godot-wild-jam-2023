extends Label

func _on_animation_player_label_animation_finished(_anim_name):
	queue_free()

func playAnimation(direction):
	if direction=="UP" : $AnimationPlayerLabel.play("JuicyLabelPop")
	if direction=="DOWN" : $AnimationPlayerLabel.play("JuicyLabelPop_2")
