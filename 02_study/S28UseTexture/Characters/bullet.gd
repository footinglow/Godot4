extends CharacterBody3D

@export var m_v_dir = Vector3.FORWARD
@export var m_d_speed_mps = 2.0

@export var m_attack_power_ps = 1.0
@export var m_hp = 1

var m_v3_sensing_pos = null
var m_v3_enemy_pos = null

# 通過したMultiplicationAreaを記憶するための辞書
var m_dict_multiarea_ids = {}

func _physics_process(delta):
	if m_v3_enemy_pos:
		m_v_dir = m_v3_enemy_pos - transform.origin
	else:
		m_v_dir = Vector3.FORWARD
	velocity = m_v_dir.normalized() * m_d_speed_mps
	move_and_slide()
	
	# バトル判定
	var battle_pos = null
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if (collision.get_collider() == null):
			continue
		if collision.get_collider().is_in_group("EnemyGroup"):
			var enemy = collision.get_collider()

			# バトル中に相手の位置を保持
			battle_pos = enemy.transform.origin

			# Bulletの攻撃
			enemy.m_hp -= m_attack_power_ps * delta
			# Enemyの攻撃
			m_hp       -= enemy.m_attack_power_ps * delta

	# HPが0になったら消える
	if m_hp < 0:
		queue_free()

	# アニメーションの設定
	if battle_pos:
		$DesignMySoldier.animation_play("Battle")
	else:
		$DesignMySoldier.animation_play("Walk")
	
	# バトル中の相手、センシングした敵の順に目標位置を設定する
	if battle_pos:
		m_v3_enemy_pos = battle_pos
	elif m_v3_sensing_pos:
		if (m_v3_sensing_pos - transform.origin).length() < 0.1:
			m_v3_sensing_pos = null
		m_v3_enemy_pos = m_v3_sensing_pos
	else:
		m_v3_enemy_pos = null
	
func discover_enemy(enemy_pos):
	m_v3_sensing_pos = enemy_pos
	
func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()

func _on_multiplication_area_detecter_area_entered(area):
	if m_dict_multiarea_ids.has(area.get_instance_id()):
		pass
	else:
		# 倍率2の場合1人、倍率2倍の場合ふたりと倍率-1人増える
		var i_add_num = area.m_i_magnification - 1
		var d_add_x = -0.15
		var d_add_z = 0.1
		for i in range(i_add_num):
			m_dict_multiarea_ids[area.get_instance_id()] = true
			var avater = duplicate()
			avater.m_dict_multiarea_ids = m_dict_multiarea_ids.duplicate(true)
			avater.transform.origin += Vector3(d_add_x, 0, d_add_z)
			add_sibling(avater)
			
			d_add_z = -d_add_z
			d_add_x += 0.1
