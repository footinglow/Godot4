extends Node3D

var m_f_is_entered_enemy_bullet = false

func is_stage_clear():
	return get_tree().get_nodes_in_group("TargetEnemy").size() == 0

func is_stage_failed():
	return m_f_is_entered_enemy_bullet
	
func _on_enemy_bullet_sensor_body_entered(body):
	m_f_is_entered_enemy_bullet = true
