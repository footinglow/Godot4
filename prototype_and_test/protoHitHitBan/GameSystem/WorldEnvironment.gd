extends WorldEnvironment

@export var m_d_speed_degps = -5.0		# 回転速度 [degree/sec]

func _process(delta):
	get_environment().sky_rotation.x += deg_to_rad(m_d_speed_degps * delta)
