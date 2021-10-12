extends Camera2D

export(NodePath)var PlayerPath:NodePath

var _player:Player=null

func _ready():
	_player=get_node(PlayerPath)

func _process(_delta:float)->void:
	if _player!=null:
		position=_player.position
