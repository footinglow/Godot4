extends Node3D

@export var m_d_rotate_speed = 7.0

func _physics_process(delta):
	var v3_gyro_rad = Input.get_gyroscope()
	rotate_y( -v3_gyro_rad.y * delta * m_d_rotate_speed)

