extends CharacterBody3D

@export var m_v_dir = Vector3(0.0, 0.0, -1.0)
@export var m_d_speed_mps = 2.0

func _physics_process(delta):
	velocity = m_v_dir.normalized() * m_d_speed_mps
	move_and_slide()

func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
