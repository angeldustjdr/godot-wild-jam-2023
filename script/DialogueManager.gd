extends Node

var Dialogues = {}
var isReady = false

func _ready():
	readDialogueFile("res://dialogue.txt")

func readDialogueFile(path):
	var f = FileAccess
	var rawDialogue = f.get_file_as_string(path)
	rawDialogue = rawDialogue.replace("\r","")
	rawDialogue = rawDialogue.split("\n")
	for line in rawDialogue: 
		if line != "":
			line = line.split("/")
			Dialogues[line[0]] = [line[1],line[2]]
	isReady = true

