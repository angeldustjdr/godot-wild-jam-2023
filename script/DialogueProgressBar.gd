extends TextureProgressBar

@onready var timer = $Timer
signal maxReached

func startTimer():
	if timer.is_stopped() : 
		self.visible = true
		timer.start()

func stopTimer():
	self.value = 0.
	timer.stop()
	self.visible = false

func _on_timer_timeout():
	if self.value < self.max_value: self.value += 1
	else : maxReached.emit()
