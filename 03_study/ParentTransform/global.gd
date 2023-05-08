extends Node3D

func _ready():
	var child  : MeshInstance3D = $Parent/Child
	var parent : MeshInstance3D = $Parent
	var global : Node3D         = $"."
	
	print("child pos(x,y,z)")
	print("  local             :", child.position)
	print("  parent coordinate :", parent.transform * child.position)
	print("  global coordinate :", global.transform * parent.transform * child.position)
	print("  global_position   :", child.global_position)
