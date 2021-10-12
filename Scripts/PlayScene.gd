extends CanvasLayer
class_name PlayScene

const CHECKPOINT_SCENE_NAME:="checkpoint.tscn"
#const LEVEL_PRAFAB=preload("res://Scenes/Level01.tscn")
export(PackedScene)var LevelPackedScene:PackedScene
onready var PlayMenu=$HUD/PlayMenu as PlayMenu
#onready var Level=$Level01 as LevelScene
var _level:LevelScene

func _ready():
	_level=LevelPackedScene.instance()
	add_child(_level)
	Asserts.OK(_level.connect("sig_replay_level",self,"_replay_level"))
	Asserts.OK(_level.connect("sig_save_level",self,"_save_level"))

func _replay_level()->void:
	Asserts.OK(get_tree().reload_current_scene())

func _save_level()->void:
	var packet_scene:=PackedScene.new()
	Asserts.OK(packet_scene.pack(_level))
	Asserts.OK(ResourceSaver.save(CHECKPOINT_SCENE_NAME,packet_scene))
