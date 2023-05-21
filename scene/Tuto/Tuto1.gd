extends Control

@onready var dialog = load("res://scene/DialogueText.tscn")
@export var startingPoint = "tuto1"
@onready var end = false
@onready var rideau=get_parent().get_node("Rideau")

func _ready():
	RadioDiffusion.connect("endDialogue",endDialogue)
	var d = dialog.instantiate()
	add_child(d)

func endDialogue():
	end = true

func _input(event):
	if event is InputEventMouseButton and end:
		if event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
			rideau.actionRideau("out")
			await rideau.get_node("AnimationPlayer").animation_finished
			get_tree().change_scene_to_file("res://scene/Tuto/Tuto2.tscn")

func _on_play_pressed():
	rideau.actionRideau("out")
	await rideau.get_node("AnimationPlayer").animation_finished
	get_tree().change_scene_to_file("res://Main.tscn")
