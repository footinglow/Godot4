extends Node3D

@export var m_ray_length_m = 1000		# [m]十分な長さにする
	
var m_touch_pos = Vector2.ZERO
var m_f_is_screen_touch = false
var m_f_pre_is_screen_touch = false

func _input(event):
	if ( event is InputEventScreenDrag ) or ( event is InputEventScreenTouch ):
		m_touch_pos = event.position
		# スマホタッチ中フラグ
		m_f_is_screen_touch = event.is_pressed() or ( event is InputEventScreenDrag )
		
func _physics_process(delta):
	# 前周期はタッチしていなくて、今周期でタッチした場合を検出したい
	if m_f_is_screen_touch and !m_f_pre_is_screen_touch:
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
			print("result.position:", result.position)
			add_vertex_position(result.position)

	# 今週機のタッチ/タッチしていない状態を保存する
	m_f_pre_is_screen_touch = m_f_is_screen_touch	

@onready var m_vertex_list = Array()
@onready var m_triangle_vertex_list = Array()

func add_vertex_position(v3_pos):
	# Line Strip
	m_vertex_list.append(v3_pos)
	create_linestrip_array_mesh(m_vertex_list)

	# Triangle
	m_triangle_vertex_list.append(v3_pos)
	if m_triangle_vertex_list.size() >= 3:
		create_triangle_array_mesh(m_triangle_vertex_list)
		m_triangle_vertex_list.clear()
		
func create_linestrip_array_mesh(vertex_list):
	var vertices = PackedVector3Array()
	
	for v3 in vertex_list:
		vertices.push_back(v3)

	var arrays = Array()
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	var tmpMesh = ArrayMesh.new()
	tmpMesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINE_STRIP, arrays)
	$ArrayMeshLineStrip.mesh = tmpMesh

var m_material = preload("res://triangle_material.tres")

func create_triangle_array_mesh(vertex_list):
	var vertices = PackedVector3Array()
	var normals = PackedVector3Array()
	
	for v3 in vertex_list:
		v3.y = 0.1
		vertices.push_back(v3)
		normals.push_back(Vector3.UP)

	var arrays = Array()
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_NORMAL] = normals
	var tmpMesh = ArrayMesh.new()
	tmpMesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	$ArrayMeshTriangle.mesh = tmpMesh

	# Materialを設定
	#var material = StandardMaterial3D.new()
	#material.albedo_color = Color(0, 1, 0)
	#$ArrayMeshTriangle.mesh.surface_set_material(0, material)
	$ArrayMeshTriangle.mesh.surface_set_material(0, m_material)
 
	# MeshからCollision形状(ConcavePolygonShape3D)生成
	$Area3D/CollisionShape3D.shape = tmpMesh.create_trimesh_shape()
	
