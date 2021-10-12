extends Control

onready var FullScreenCheck:=$Panel/CenterContainer/VBoxContainer/GridContainer/FullScreenCheck as CheckBox

func _ready():
	#OS.set_window_size(Vector2(640, 480))
	pass

func _on_ResolutionOption_item_selected(index):
	pass # Replace with function body.

func _on_AcceptButton_pressed():
	OS.window_fullscreen=FullScreenCheck.pressed
