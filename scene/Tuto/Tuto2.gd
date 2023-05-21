extends Control

@onready var dialog = load("res://scene/DialogueText.tscn")
@export var startingPoint = "tuto5"
@export var waittime = 5
@onready var end = false
@onready var rideau=get_parent().get_node("Rideau")

func _ready():
	RadioDiffusion.connect("endDialogue",endDialogue)
	var d = dialog.instantiate()
	d.startingPoint = startingPoint
	add_child(d)

func endDialogue():
	await get_tree().create_timer(waittime).timeout
	end = true

func _input(event):
	if event is InputEventMouseButton and end:
		if event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
			rideau.actionRideau("out")
			await rideau.get_node("AnimationPlayer").animation_finished
			get_tree().change_scene_to_file("res://Main.tscn")


func _on_play_pressed():
	rideau.actionRideau("out")
	await rideau.get_node("AnimationPlayer").animation_finished
	get_tree().change_scene_to_file("res://Main.tscn")
