extends StateNode
class_name Patrol

export(NodePath)var LinePatrolPath
export(Array,Vector2)var PatrolPath
var _next_state_name:String
var _patrol_path2d:Path2D
var _patrol_points:PoolVector2Array
var _point_index:int

func _ready():
	_next_state_name=name
#	_patrol_path2d=get_node(LinePatrolPath) as Path2D
#	_patrol_points=_patrol_path2d.curve.get_baked_points()
#	_point_index=0

func process(_delta:float)->String:
#	if _patrol_points:
#		var target_point:=_patrol_points[_point_index]
#		if position.distance_to(target_point)<1:
#			_point_index=wrapi(_point_index+1,0,_patrol_points.size())
#			target_point=_patrol_points[_point_index]
#		velocity=(target_point-position).normalized()*move_speed
#		velocity=move_and_slide(velocity)
	return _next_state_name
