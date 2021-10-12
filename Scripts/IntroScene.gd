extends Node

func _on_PlayButton_pressed():
	assert(OK==get_tree().change_scene("res://Scenes/PlayScene.tscn"),"Error")

func _on_QuitButton_pressed():
	get_tree().quit()
