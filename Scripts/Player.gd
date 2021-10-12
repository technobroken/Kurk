extends Character2D
class_name Player

signal sig_player_enter_room(area)
signal sig_player_dead()
const SHOT_PREFAB:=preload("res://Prefabs/Bullet.tscn")
export(String)var RoomName:=""
var _is_in_lift:bool
var _gun:Gun=null

func _ready():
	_is_in_lift=false

func _physics_process(delta:float)->void:
	if _is_alive:
		var input_h:=int(Input.is_action_pressed("RIGHT"))-int(Input.is_action_pressed("LEFT"))

		if input_h<0 and SideOfLook==ESideOfLook.RIGHT:
			SideOfLook=ESideOfLook.LEFT
			Flipeable.scale.x=-1
		elif input_h>0 and SideOfLook==ESideOfLook.LEFT:
			SideOfLook=ESideOfLook.RIGHT
			Flipeable.scale.x=+1

		if input_h!=0:
			AnimationPlayer.play("WALK")
		else:
			AnimationPlayer.play("IDLE")
		
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

func _on_HitBox_area_entered(area:Area2D)->void:
	if area.is_in_group("COLLECTIBLES"):
		_sensor_collectible(area as Collectible)
	elif area.is_in_group("ROOMS"):
		emit_signal("sig_player_enter_room",area)
		RoomName=area.name
	elif area.is_in_group("LIFT"):
		_is_in_lift=true

func _on_HitBox_area_exited(area:Area2D)->void:
	if area.is_in_group("LIFT"):
		_is_in_lift=false

func _sensor_collectible(item:Collectible)->void:
	match item.Type:
		Collectible.EType.Gun:
			_gun=_pick_gun(item.Prefab,GunPosition)
			item.queue_free()

func _pick_gun(prefab:PackedScene,node_container:Node)->Gun:
	NodeTools.free_children(node_container)
	var gun:=prefab.instance() as Gun
	node_container.add_child(gun)
	return gun

func _vt_dead():
	_is_alive=false
	HitBox.visible=false
	AnimationPlayer.play("DEAD")
	yield(AnimationPlayer,"animation_finished")
	emit_signal("sig_player_dead")



