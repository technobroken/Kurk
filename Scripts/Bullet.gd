extends KinematicBody2D
class_name Bullet

export(float) var Speed:float
var _dir_x:float
var _velocity:Vector2

func setup(origin:Vector2,dir_x:float)->void:
	_dir_x=dir_x
	_velocity=Vector2(Speed*dir_x,0)
	position=origin

func _ready()->void:
	pass # Replace with function body.

func _physics_process(delta:float)->void:
	var collisions:=move_and_collide(_velocity*delta)
	if collisions!=null:
		_dead()
		if collisions.collider is Character2D:
			var character:=collisions.collider
			character.take_damage(-1)

func _on_VisibilityNotifier2D_screen_exited():
	_dead()

func _dead()->void:
	queue_free()
