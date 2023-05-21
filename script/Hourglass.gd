extends Label

var turnLeft
@onready var parent = self.get_parent()

func _ready():
	GameState.connect("transfertNbAction",decreaseTimer)

func init(type="sablier"):
	var hourglass
	if type=="sablier": hourglass = load("res://scene/HourglassDestroy.tscn")
	else: hourglass = load("res://scene/HourglassLock.tscn")
	var h = hourglass.instantiate()
	add_child(h)

func setTimer(n):
	turnLeft = n
	self.text = str(n)
	if n<=10:
		$AnimationPlayer.play("flash")
	if n==0:
		if parent.locked : 
			parent.unsetLock()
			parent.updateTooltip()
		else : parent.selfDestruct("Empty")

func decreaseTimer():
	if turnLeft >= 0:
		setTimer(turnLeft-1)
		get_node("Hourglass/AnimationPlayerHourglass").play("rotateHourglass")
