extends CharacterBody3D

@export var m_d_max_size = 2.0

var m_d_balloon_size = 1.0

func _on_sensor_laser_area_entered(area_laser):
	if area_laser.is_in_group("LASER"):
		# balloonを大きくする
		m_d_balloon_size += area_laser.m_d_laser_power
		scale = Vector3(1,1,1) * m_d_balloon_size
		
		# あたったときのアニメーション
		$AnimationPlayer.play("hit")
		
		# レーザーを消す
		area_laser.queue_free()
	else:
		pass
