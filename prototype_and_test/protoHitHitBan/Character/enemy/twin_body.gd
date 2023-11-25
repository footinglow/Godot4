extends CharacterBody3D

@export var _d_speed_mps = 2.0

func _physics_process(delta):
	velocity = Vector3(0, 0, _d_speed_mps)
	move_and_slide()
