extends CharacterBody3D

@export var m_attack_power_ps = 0.5
@export var m_hp = 0.5

@export var m_v_dir = Vector3.BACK
@export var m_d_speed_mps = 1.0

func _physics_process(delta):
	velocity = m_v_dir.normalized() * m_d_speed_mps
	move_and_slide()
	if m_hp < 0.0:
		queue_free()
		
func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
