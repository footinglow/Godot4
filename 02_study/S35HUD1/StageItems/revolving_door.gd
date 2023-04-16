extends StaticBody3D

@export var m_d_speed_degps = 0.2	# 1秒あたりに回転する角度[degree/s]

func _physics_process(delta):
	rotate_y( m_d_speed_degps * delta )
