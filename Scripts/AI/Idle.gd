extends StateNode
class_name Idle

func _ready():
	pass # Replace with function body.

func enter()->void:
	pass

func exit()->void:
	pass

func process(_delta:float)->String:
	var next_state_name:="Patrol"
	return next_state_name
