extends StaticBody3D

@export var m_d_extents = 2.0
@export var m_d_speed_mps = 1.0

var m_v3_init_pos
var m_d_now_speed_mps = m_d_speed_mps

func _ready():
	m_v3_init_pos = transform.origin

func _physics_process(delta):
	transform.origin.x += m_d_now_speed_mps * delta
	if absf(transform.origin.x - m_v3_init_pos.x) >= m_d_extents:
		m_d_now_speed_mps = -m_d_now_speed_mps
