extends KinematicBody2D
class_name Character2D

enum ESideOfLook{LEFT=-1,RIGHT=+1}
export(ESideOfLook)var SideOfLook:=ESideOfLook.RIGHT
export(float)var Speed:=100.0
onready var ViewPortRect:=get_viewport_rect()
onready var AnimationPlayer:=$AnimationPlayer as AnimationPlayer
onready var Flipeable:=$Flipeable as Node2D
onready var GunPosition:=$Flipeable/GunPosition as Node2D
onready var HitBox:=$HitBox as Area2D
var _velocity:Vector2
var _is_alive:bool
var _is_on_screen:bool

func take_damage(_damage:float)->void:
	if _is_on_screen and _is_alive:
		_vt_dead()

func _ready():
	_velocity=Vector2.ZERO
	_is_alive=true
	Flipeable.scale.x=SideOfLook

func _vt_dead()->void: pass

#func _is_on_screen()->bool:
#	return _is_on_screen
#	var offset:=0
#	if position.x-offset>ViewPortRect.position.x and position.x+offset<ViewPortRect.size.x:
#		return true
#	return false

func _on_VisibilityNotifier2D_screen_entered():
	_is_on_screen=true

func _on_VisibilityNotifier2D_screen_exited():
	_is_on_screen=false
