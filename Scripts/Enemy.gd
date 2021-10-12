extends NPC
class_name Enemy

const SHOT_PREFAB:=preload("res://Prefabs/Bullet.tscn")
onready var DelayShotTimer=$Timer
onready var Gun=$Flipeable/GunPosition/Gun
onready var Ray=$Flipeable/RayCast2D
onready var StateMachine:=$StateMachine
var _can_shoot:bool
var _is_shooting:bool

func _ready():
	_can_shoot=false
	_is_shooting=false
	GunPosition.visible=false

func _physics_process(_delta:float):
	var _character_in_ray:=_get_character_in_ray(Ray)
	match State:
		EState.IDLE:
			pass
		EState.Walk:
			if _character_in_ray!=null:
				_to_run()
		EState.Run:
			if _character_in_ray==null:
				_to_walk()
			elif global_position.distance_to(_character_in_ray.global_position)<170:
				_to_shoot()
		EState.Shoot:
			if _character_in_ray==null:
				_to_walk()
		EState.Dead:
			pass
	
	#_velocity.x=lerp(_velocity.x,Speed*int(SideOfLook),0.2)
	#_velocity=move_and_slide(_velocity,Vector2.UP)

	if _is_shooting:
		if not _can_shoot and DelayShotTimer.is_stopped():
			DelayShotTimer.start(0.1)
		if _can_shoot:
			Gun.shot(SHOT_PREFAB,Flipeable.scale.x,BulletContainer.container)

func _on_Timer_timeout():
	_can_shoot=true

func _on_HitBox_body_entered(body:Node)->void:
	if body.is_in_group("FRIENDS") and body is Character2D:
		var character:=body as Character2D
		var direction:=global_position.direction_to(character.global_position)
		if direction.x>0:
			SideOfLook=ESideOfLook.RIGHT
		else:
			SideOfLook=ESideOfLook.LEFT

func _vt_dead()->void:
	_is_alive=false
	HitBox.visible=false
	AnimationPlayer.play("DEAD")
	Speed=0.0
	State=EState.Dead
	yield(AnimationPlayer,"animation_finished")
	queue_free()

func _to_walk():
	._to_walk()
	_is_shooting=false
	GunPosition.visible=false

func _to_run():
	._to_run()
	GunPosition.visible=true

func _to_shoot():
	._to_shoot()
	_is_shooting=true

func _get_character_in_ray(ray:RayCast2D)->Character2D:
	if ray.is_colliding():
		var collider:=ray.get_collider()
		if collider!=null and collider is Character2D:
			var character:=collider as Character2D
			if character.is_in_group("FRIENDS"):
				if character._is_alive:
					return character
	return null
