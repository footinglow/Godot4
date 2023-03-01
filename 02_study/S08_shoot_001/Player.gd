extends CharacterBody3D

@export var m_speed_mps = 5.0
@export var m_ray_length_m = 1000		# [m]十分な長さにする
@export var m_scn_bullet : PackedScene

var m_touch_pos = Vector2.ZERO
var m_d_move_to_pos_x_m = 0
var m_f_is_screen_touch = false

func _input(event):
	if ( event is InputEventScreenDrag ) or ( event is InputEventScreenTouch ):
		m_touch_pos = event.position
		# スマホタッチ中フラグ
		m_f_is_screen_touch = event.is_pressed() or ( event is InputEventScreenDrag )

func _physics_process(delta):
	var camera = get_viewport().get_camera_3d()

	# カメラを利用して3D空間のカメラ位置とタッチしたピクセルに対応する方向の1000m先の位置を計算する
	var from3d = camera.project_ray_origin(m_touch_pos)
	var to3d = from3d + camera.project_ray_normal(m_touch_pos) * m_ray_length_m

	# 3D ray physics queryの作成
	var query = PhysicsRayQueryParameters3D.create(from3d, to3d)
	query.collide_with_areas = true		# Area3Dを検知できるようにする
	
	# Godotの3Dの物理とコリジョンを保存しているspaceという情報を使用してオブジェクト検出
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(query)
	if result:
		m_d_move_to_pos_x_m = result.position.x

	# 移動制御は毎周期実行する
	var d_diff_x_m = (m_d_move_to_pos_x_m - transform.origin.x);
	var d_speed_mps = m_speed_mps if d_diff_x_m>0 else -m_speed_mps
	var d_move_diff_x_m = d_speed_mps * delta
	if absf(d_move_diff_x_m) > absf(d_diff_x_m):
		# 移動すると目標位置を超えるため、目標位置を設定する
		transform.origin.x = m_d_move_to_pos_x_m
	else:
		move_and_collide(Vector3(d_move_diff_x_m, 0, 0))

func _on_timer_fire_timeout():
	# スマホタッチ中の場合、発射する
	if m_f_is_screen_touch:
		var scn_bullet = m_scn_bullet.instantiate()
		scn_bullet.transform.origin = $Marker3D.global_transform.origin
		add_sibling(scn_bullet)
