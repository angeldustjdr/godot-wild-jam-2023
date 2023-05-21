extends Node

var num_players = 8
var bus = "master"

var available = []  # The available players.
var queue = []  # The queue of sounds to play.
var queue_vol = []  # Volume of the queued sounds.
var queue_pitch = []  # Pitch of the queued sounds.

var sound_paths = {	"clic":"res://asset/sound/click1.ogg",
					"transition":"res://asset/sound/woosh7.ogg", 
					"powerup":"res://asset/sound/powerUp7.ogg", 
					"powerdown":"res://asset/sound/lowDown.ogg",
					"build":"res://asset/sound/stoneDragHit1.ogg",
					"destroy":"res://asset/sound/rumble3.ogg",
					"casserole":"res://asset/sound/Casserole.wav", 
					"casserole_one_hit":"res://asset/sound/Casserole-cut.mp3", 
					"swap":"res://asset/sound/cardTakeOutPackage1.ogg",
					"lock":"res://asset/sound/footstep00.ogg", 
					"timer":"res://asset/sound/bookFlip3.ogg"}

var base_volumes = {"clic":0.0,
					"transition":0.0,
					"powerup":0.0,
					"powerdown":0.0,
					"build":5.0,
					"destroy":-5.0,
					"casserole":0.0,
					"casserole_one_hit":0.0,
					"swap":0.0,
					"lock":0.0,
					"timer":0.0}

var base_pitches = {"clic":1.0,
					"transition":1.0,
					"powerup":1.0,
					"powerdown":1.0,
					"build":1.0,
					"destroy":1.0,
					"casserole":1.0,
					"casserole_one_hit":1.0,
					"swap":1.0,
					"lock":1.0,
					"timer":1.0}

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
	self.queue_vol.append(self.base_volumes[sound_name])
	self.queue_pitch.append(self.base_pitches[sound_name])

func _process(_delta):
	# Play a queued sound if any players are available.
	if not queue.is_empty() and not available.is_empty():
		available[0].stream = load(queue.pop_front())
		available[0].volume_db = queue_vol.pop_front()
		available[0].pitch_scale = queue_pitch.pop_front()
		available[0].play()
		available.pop_front()
