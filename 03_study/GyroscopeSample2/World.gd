extends Node3D

func _physics_process(delta):
	var v3_gyro_rad = Input.get_gyroscope()
	rotate_y(  v3_gyro_rad.z * delta)
	rotate_z( -v3_gyro_rad.y * delta)
	rotate_x(  v3_gyro_rad.x * delta)
