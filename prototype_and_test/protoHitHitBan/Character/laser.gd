extends Area3D

@export var m_speed_mps = 20.0
@export var m_d_laser_power = 0.1

func set_pos(player_pos):
	global_position = player_pos
	
func _physics_process(delta):
	global_position += Vector3(0, 0, -1) * m_speed_mps * delta

# 画面外に出た場合、消える
func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
