extends Area3D

@export var _d_dir = Vector3(0, 0, 1)
@export var _d_speed_mps = 4
@export var _d_speed_degps = 30


func _physics_process(delta):
	rotate_y( deg_to_rad(_d_speed_degps) * delta )
	global_position += _d_dir.normalized() * _d_speed_mps * delta
