extends Node2D
class_name Gun

export(float)var recoil_time:float=1.0
onready var Position:=$Position2D as Position2D
onready var Timer:=$Timer as Timer
var _can_shoot:bool

func shot(prefab:PackedScene,dir_x:float,container:Node)->void:
	if _can_shoot:
		var shot:=prefab.instance() as Bullet
		shot.setup(Position.global_position,dir_x)
		container.add_child(shot)
		_can_shoot=false
		Timer.start(recoil_time)

func _ready():
	_can_shoot=true

func _on_Timer_timeout():
	_can_shoot=true
