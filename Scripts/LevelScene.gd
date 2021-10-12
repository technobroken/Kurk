extends Node2D
class_name LevelScene

signal sig_replay_level()
signal sig_save_level()
onready var Player:=$Player as Player
onready var Camera:=$Camera2D as Camera2D
var _room:RoomHitBox

func _ready():
	_room=null
	modulate=Color.white
	BulletContainer.container=$Objects
	Asserts.OK(Player.connect("sig_player_enter_room",self,"_room_entered"))
	Asserts.OK(Player.connect("sig_player_dead",self,"_player_dead"))

func _player_dead():
	$Timer.start(3)
	yield($Timer,"timeout")
	modulate=Color.black
	$Timer.start(3)
	yield($Timer,"timeout")
	emit_signal("sig_replay_level")

func _room_entered(room_hit_box:RoomHitBox)->void:
	if _room!=null:
		var offset:=_room.position.direction_to(room_hit_box.position)
		if offset.x!=0:
			Player.position.x+=12*offset.x
		if offset.y!=0:
			Player.position.y+=12*offset.y
	var room_size:=room_hit_box.get_size()
	Camera.limit_left=int(room_hit_box.global_position.x-room_size.x/2)
	Camera.limit_top=int(room_hit_box.global_position.y-room_size.y/2)
	Camera.limit_right=int(Camera.limit_left+room_size.x)
	Camera.limit_bottom=int(Camera.limit_top+room_size.y)
	Camera.position.x=Player.position.x
	_room=room_hit_box
