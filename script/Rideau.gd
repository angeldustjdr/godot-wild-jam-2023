extends ColorRect

func _ready():
	RadioDiffusion.connect("rideau",actionRideau)

func actionRideau(sens):
	$AnimationPlayer.play("rideau_"+sens)
	await $AnimationPlayer.animation_finished
	RadioDiffusion.rideauFinishedCall()
