extends Control
class_name PlayMenu

func _input(event:InputEvent)->void:
	if event.is_action_pressed("ui_cancel"):
		_show(not visible,self)

func _on_Continue_pressed():
	_show(false,self)

func _on_Close_pressed():
	_show(false,self)
	assert(OK==get_tree().change_scene("res://Scenes/IntroScene.tscn"))

func _on_Settings_pressed():
	pass # Replace with function body.

static func _show(flag:bool,node:Control)->void:
	node.get_tree().paused=flag
	node.visible=flag
