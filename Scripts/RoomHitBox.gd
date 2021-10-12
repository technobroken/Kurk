extends Area2D
class_name RoomHitBox

export(Vector2)var Size:Vector2=Vector2(240,135)

func get_size()->Vector2:
	return Size

func _ready():
	var rect_shape=$CollisionShape2D.shape
	rect_shape.extents=Size/2
