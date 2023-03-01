extends CharacterBody3D

@export var m_ray_length_m = 1000		# [m]十分な長さにする
var m_touch_pos = Vector2.ZERO

func _input(event):
	if ( event is InputEventScreenDrag ) or ( event is InputEventScreenTouch ):
		m_touch_pos = event.position

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
		print(result)
