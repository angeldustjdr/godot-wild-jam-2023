extends Area2D

@onready var status = "techno"
@onready var initialScale = self.scale
@onready var initialPosition = self.position
signal tutoWell

func _on_control_gui_input(event):
	if event is InputEventMouseButton:
			if event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
				match status:
					"techno":
						$Destroy.visible = true
						status = "detroyable"
					"empty":
						$Build.visible = true


func _on_control_mouse_entered():
	$DemoSprite2.material.set_shader_parameter("width",2.)


func _on_control_mouse_exited():
	$DemoSprite2.material.set_shader_parameter("width",0.)

func reset():
	self.position = initialPosition
	self.scale = initialScale


func _on_destroy_pressed():
	$DustParticule.visible = true
	$DemoSprite2/AnimationPlayer.play("destroy")
	await $DemoSprite2/AnimationPlayer.animation_finished
	$DustParticule.visible = false
	$DemoSprite2.texture = load("res://asset/sheet/sheet_last_v/empty-space-sheet.png")
	$DemoSprite2/AnimationPlayer.play("build")
	$Destroy.visible = false
	await $DemoSprite2/AnimationPlayer.animation_finished
	$Tooltip.tooltip_text = "An empty space to build on."
	status = "empty"


func _on_build_pressed():
	$DemoSprite2.texture = load("res://asset/sheet/sheet_last_v/well-sheet.png")
	$DemoSprite2/AnimationPlayer.play("build")
	$Build.visible = false
	await $DemoSprite2/AnimationPlayer.animation_finished
	$Tooltip.tooltip_text = "Fresh water for everyone."
	status = "finish"
	tutoWell.emit()
	
