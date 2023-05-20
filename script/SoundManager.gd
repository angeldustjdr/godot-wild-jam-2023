extends Node

var num_players = 8
var bus = "master"

var available = []  # The available players.
var queue = []  # The queue of sounds to play.

var sound_paths = {	"clic":"res://asset/sound/blip-2.wav",
					"transition":"res://asset/sound/blip-1.wav",
					"powerup":"res://asset/sound/powerUp-v2.wav",
					"build":"res://asset/sound/corruption-v1.wav",
					"destroy":"res://asset/sound/explosion-v1.wav"}

func _ready():
	# Create the pool of AudioStreamPlayer nodes.
	for i in num_players:
		var p = MyAudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.myfinished.connect(self._on_stream_finished)
		p.bus = bus


func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	available.append(stream)


func play(sound_path):
	queue.append(sound_path)

func playSoundNamed(sound_name):
	self.play(self.sound_paths[sound_name])

func _process(_delta):
	# Play a queued sound if any players are available.
	if not queue.is_empty() and not available.is_empty():
		available[0].stream = load(queue.pop_front())
		available[0].play()
		available.pop_front()
