extends KinematicBody2D
class_name Pla

signal sig_player_dead()
signal sig_room_entered(area)
const SHOT_PREFAB:=preload("res://Prefabs/ShotPlayer.tscn")
enum EState{Alive,Dead}
enum ELookSide{Left=-1,Right=+1}
export(ELookSide) var LookSide=ELookSide.Right setget _set_look
export(float)var Speed:float
export(EState)var State:=EState.Alive
export(String)var RoomName:=""
onready var Flipeable:=$Flipeable as Node2D
onready var GunPivot:=$Flipeable/GunPivot as Position2D
onready var Animation:=$AnimationPlayer as AnimationPlayer
onready var HitBox:=$HitBox as Area2D
var _velocity:Vector2
var _gun:Gun=null
var _is_in_lift:bool

func _set_look(side)->void:
	$Flipeable.scale.x=side

func _get_look()->int:
	return $Flipeable.scale.x

func _ready():
	_is_in_lift=false
	_velocity=Vector2.ZERO

func _physics_process(delta:float)->void:
	if State==EState.Alive:
		var input_h:=int(Input.is_action_pressed("RIGHT"))-int(Input.is_action_pressed("LEFT"))

		if input_h<0 and Flipeable.scale.x>0:
			Flipeable.scale.x=-1
		elif input_h>0 and Flipeable.scale.x<0:
			Flipeable.scale.x=+1
		
		if input_h!=0:
			Animation.play("WALK")
		else:
			Animation.play("IDLE")
		
		if _is_in_lift:
			var input_v:=int(Input.is_action_pressed("UP"))-int(Input.is_action_pressed("DOWN"))
			if input_v>0:#UP
				_velocity.y=-50
			elif input_v<0:#DOWN
				_velocity.y=+50
			else:
				_velocity.y=lerp(_velocity.y,0,0.1)
		else:
			_velocity.y+=500*delta

		_velocity.x=input_h*Speed

		if _gun!=null and Input.is_action_pressed("SHOOT"):
			_gun.shot(SHOT_PREFAB,Flipeable.scale.x,BulletContainer.container)

		_velocity=move_and_slide(_velocity,Vector2.UP)
	elif State==EState.Dead:
		pass

func _sensor_collectible(item:Collectible)->void:
	match item.Type:
		Collectible.EType.Gun:
			_gun=_pick_gun(item.Prefab)
			item.queue_free()

func _pick_gun(prefab:PackedScene)->Gun:
	NodeTools.free_children(GunPivot)
	var gun:=prefab.instance() as Gun
	GunPivot.add_child(gun)
	return gun

func _dead():
	State=EState.Dead
	HitBox.visible=false
	Animation.play("DEAD")
	yield(Animation,"animation_finished")
	emit_signal("sig_player_dead")

func _on_HitBox_area_entered(area:Area2D):
	if area.is_in_group("COLLECTIBLES"):
		_sensor_collectible(area as Collectible)
	elif area.is_in_group("SHOT"):
		area.queue_free() #borrar el shot para que no me traspase
		if State!=EState.Dead:
			_dead() #matar al actor
	elif area.is_in_group("ROOMS"):
		emit_signal("sig_room_entered",area)
		RoomName=area.name
	elif area.is_in_group("LIFT"):
		_is_in_lift=true

func _on_HitBox_area_exited(area):
	if area.is_in_group("LIFT"):
		_is_in_lift=false
