extends CharacterBody3D

@export var m_v_dir = Vector3.FORWARD
@export var m_d_speed_mps = 2.0

var m_v3_enemy_pos = null

func _physics_process(delta):
	if m_v3_enemy_pos:
		m_v_dir = m_v3_enemy_pos - transform.origin
	else:
		m_v_dir = Vector3.FORWARD
	velocity = m_v_dir.normalized() * m_d_speed_mps
	move_and_slide()

func discover_enemy(enemy_pos):
	m_v3_enemy_pos = enemy_pos
	
func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
