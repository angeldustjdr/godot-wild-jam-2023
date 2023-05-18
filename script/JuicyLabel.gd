extends Label

var animationTime = 0.5

func init(pos,myText,dir):
	self.global_position = pos
	self.text = myText
	playAnimation(dir)

func playAnimation(direction):
	var tween = get_tree().create_tween()
	var sign
	if direction=="UP" : sign = -1
	if direction=="DOWN" : sign = 1
	tween.tween_property(self, "global_position", self.global_position+Vector2(34,sign*34), animationTime)
	await get_tree().create_timer(animationTime).timeout
	queue_free()


