extends CharacterBody3D

func _on_bullet_sensor_body_entered(body):
	body.discover_enemy(transform.origin)
