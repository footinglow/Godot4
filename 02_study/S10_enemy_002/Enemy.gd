extends CharacterBody3D

@export var m_attack_power_ps = 1.0
@export var m_hp = 10

func _physics_process(delta):
	if m_hp < 0.0:
		queue_free()
	
func _on_bullet_sensor_body_entered(body):
	body.discover_enemy(transform.origin)
