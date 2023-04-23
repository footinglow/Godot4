extends Node3D

func _physics_process(delta):
	var v3_gyro_rad = Input.get_gyroscope()
	$MeshInstance3D.rotate_y( -v3_gyro_rad.z * delta)
	$MeshInstance3D.rotate_z(  v3_gyro_rad.y * delta)
	$MeshInstance3D.rotate_x( -v3_gyro_rad.x * delta)
