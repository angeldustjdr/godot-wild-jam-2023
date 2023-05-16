extends Label

var turnLeft
@onready var parent = self.get_parent()

func _ready():
	GameState.connect("transfertNbAction",decreaseTimer)

func setTimer(n):
	turnLeft = n
	self.text = str(n)
	if n<=10:
		$AnimationPlayer.play("flash")
	if n<=0:
		if parent.locked : parent.unsetLock()
		else : parent.selfDestruct("Empty")

func decreaseTimer():
	setTimer(turnLeft-1)
