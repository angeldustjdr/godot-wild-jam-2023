extends Label

@export var startingPoint = "start"
@export var typingSpeed = 0.05

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
	self.visible_characters = 0
	line = DialogueManager.Dialogues[which][0]
	nextLine = DialogueManager.Dialogues[which][1]
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
	await get_tree().create_timer(0.3).timeout
	isTyping = false
	if nextLine!= "end": waitBar.startTimer()

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_LEFT:
			if isTyping : 
				endLine()
			else : 
				await get_tree().create_timer(0.1).timeout
				startDialogue(nextLine)

func callNext():
	startDialogue(nextLine)
