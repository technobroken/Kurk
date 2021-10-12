extends Area2D
class_name ShotPlayer

export(float) var Speed:float
onready var Ray:=$RayCast2D as RayCast2D
var _dir_x:float
var _prev_position:Vector2

func init(origin:Vector2,dir_x:float)->void:
	_dir_x=dir_x
	position=origin
	_prev_position=origin

func _ready():
	pass

func _process(delta:float)->void:
	position+=transform.x*_dir_x*Speed*delta
	

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
