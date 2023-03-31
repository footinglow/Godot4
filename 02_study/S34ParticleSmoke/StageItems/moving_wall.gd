extends StaticBody3D

@export var m_d_x_extents_m = 2.0		# 初期設置位置からX方向の最大移動距離
@export var m_d_speed_mps = 1.0			# 移動速度

var m_v3_init_pos
var m_d_direction = 1

func _ready():
	m_v3_init_pos = transform.origin

func _physics_process(delta):
	transform.origin.x += m_d_speed_mps * m_d_direction * delta
	if absf(transform.origin.x - m_v3_init_pos.x) >= m_d_x_extents_m:
		m_d_direction = -m_d_direction
