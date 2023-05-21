extends Node

var musics_names = {"game":"res://asset/music/1-05. Negative Mass.mp3"}
var musics_base_volumes = {"game":0.0}
var musics_loops = {"game":true}
var current = null

# Called when the node enters the scene tree for the first time.
func _ready():
	for music_name in musics_names:
		var p = MyAudioStreamPlayer.new()
		p.name = music_name
		p.stream = load(musics_names[music_name])
		p.volume_db = musics_base_volumes[music_name]
		self.add_child(p)

func playMusicNamed(music_name):
	self.stopCurrent()
	var ap = self.get_node(music_name)
	self.current = ap
	self.current.finished.connect(self.currentIsFinished)
	ap.play()
	
func stopCurrent():
	if current != null:
		current.stop()
		
func currentIsFinished():
	if musics_loops[self.current.name]:
		self.current.play()
	else:
		self.current = null
