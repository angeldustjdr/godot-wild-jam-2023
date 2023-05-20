extends Control

@onready var rideau = get_parent().get_node("Rideau/AnimationPlayer")

func _ready():
	var myTween = create_tween()
	myTween.tween_property(self, "position", Vector2(0,-self.size.x), 10.0)
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
			rideau.play("rideau_out")
			await rideau.animation_finished
			get_tree().change_scene_to_file("res://TitleScene.tscn")
