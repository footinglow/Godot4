extends StaticBody3D

@export var m_d_speed_degps = 0.2	# 1秒あたりに開店する確度

func _physics_process(delta):
	rotate_y( m_d_speed_degps * delta )
