extends Label

var turnLeft

func _ready():
	GameState.connect("transfertNbAction",decreaseTimer)

func setTimer(n):
	turnLeft = n
	self.text = str(n)
	if n<=10:
		$AnimationPlayer.play("flash")
	if n<=0:
		get_parent().selfDestruct("Empty")

func decreaseTimer():
	setTimer(turnLeft-1)
