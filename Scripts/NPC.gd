extends Character2D
class_name NPC

enum EState{IDLE,Run,Walk,Shoot,Dead}
export(EState)var State

func _ready()->void:
	_change_state(State)

func _physics_process(_delta:float)->void:
	Flipeable.scale.x=SideOfLook
	_velocity.x=lerp(_velocity.x,Speed*int(SideOfLook),0.15)
	_velocity=move_and_slide(_velocity,Vector2.UP)

func _vt_dead()->void:
	AnimationPlayer.play("AnimationDEAD")
	Speed=0.0
	yield(AnimationPlayer,"animation_finished")
	queue_free()

func _change_state(state:int)->void:
	match state:
		EState.IDLE:
			_to_idle()
		EState.Run:
			_to_run()
		EState.Walk:
			_to_walk()
		EState.Shoot:
			_to_shoot()
		_:
			assert(false,"Unknown state %d"%[str(state)])

func _to_idle():
	AnimationPlayer.play("IDLE")
	State=EState.IDLE
	Speed=0.0

func _to_walk():
	AnimationPlayer.play("WALK")
	State=EState.Walk
	Speed=30.0

func _to_run():
	AnimationPlayer.play("WALK")
	State=EState.Run
	Speed=100.0

func _to_shoot():
	AnimationPlayer.play("IDLE")
	State=EState.Shoot
	Speed=0.0
