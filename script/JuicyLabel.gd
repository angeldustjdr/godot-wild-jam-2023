extends Label

@onready var animation = $AnimationPlayerLabel

func playAnimation(direction):
	if direction=="UP" : animation.play("JuicyLabelPop")
	if direction=="DOWN" : animation.play("JuicyLabelPop_2")
