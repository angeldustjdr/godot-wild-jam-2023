extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	RadioDiffusion.connect("endGame",endGame)

func endGame():
	self.visible = true


func _on_pressed():
	RadioDiffusion.rideauCall("out")
	GameState.reset()
	MusicManager.playMusicNamed("game")
	get_tree().change_scene_to_file("res://Main.tscn")
