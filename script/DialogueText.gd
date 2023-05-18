extends Label

@export var startingPoint = "start"
@export var typingSpeed = 0.03

var line = ""
var nextLine = "end"
var isTyping = false
@onready var timer = $Timer
@onready var waitBar = $DialogueProgressBar

func _ready():
	RadioDiffusion.connect("nextDialogPlease",startDialogue)
	waitBar.connect("maxReached",callNext)
	if DialogueManager.isReady:
		startDialogue(startingPoint)

func startDialogue(which):
	if which == "end" : return
	waitBar.stopTimer()
	isTyping = true
	line = DialogueManager.Dialogues[which][0]
	nextLine = DialogueManager.Dialogues[which][1]
	self.visible_characters = 0
	self.text = line
	timer.wait_time = typingSpeed
	timer.start()

func _on_timer_timeout():
	if self.visible_characters != line.length():
		self.visible_characters += 1
	else :
		endLine()

func endLine():
	self.visible_characters = line.length()
	timer.stop()
	await get_tree().create_timer(1).timeout
	isTyping = false
	if nextLine!= "end": waitBar.startTimer()

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_LEFT:
			if isTyping : 
				endLine()
			else : 
				callNext()

func callNext():
	startDialogue(nextLine)
