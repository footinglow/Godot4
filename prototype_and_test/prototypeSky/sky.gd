extends MeshInstance3D

@export var m_d_speed_degps = 0.0001

func _physics_process(delta):
	rotate_y(m_d_speed_degps * delta)
