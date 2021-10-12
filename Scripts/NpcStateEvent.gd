extends Area2D

enum ENpcEvent{Side=0}
export(ENpcEvent)var Event

func _on_NpcStateEvent_body_entered(body:Node)->void:
	var npc:=body as NPC
	npc.SideOfLook*=-1
