extends WorldEnvironment

@export var m_d_speed_degps = 1.0		# 回転速度 [degree/sec]

func _process(delta):
	get_environment().sky_rotation.y += deg_to_rad(m_d_speed_degps * delta)

