extends CharacterBody3D

@export var m_attack_power_ps = 1.0
@export var m_hp = 10

@export var m_scn_enemybullet : PackedScene
@export var m_i_fire_num = 3

var m_i_remain_fire_cnt = 0

func _physics_process(delta):
	if m_hp < 0.0:
		queue_free()
	
func _on_bullet_sensor_body_entered(body):
	body.discover_enemy(transform.origin)

func _on_timer_fire_timeout():
	# 発射する段数を設定
	m_i_remain_fire_cnt =  m_i_fire_num
	# タイマースタート
	$Timer_short.start()

func _on_timer_short_timeout():
	# EnemyBulletを発射する
	var scn_enemybullet = m_scn_enemybullet.instantiate()
	scn_enemybullet.transform.origin = $Marker3D.global_transform.origin
	add_sibling(scn_enemybullet)
	
	# 発射残数を減算して、０になったらタイマーを停止する
	m_i_remain_fire_cnt -= 1
	if m_i_remain_fire_cnt <= 0:
		$Timer_short.stop()
	
