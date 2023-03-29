extends MeshInstance3D

@export var m_d_speed_degps = 1		# 回転速度 [degree/sec]

func _physics_process(delta):
	rotate_y( deg_to_rad(m_d_speed_degps) * delta)
