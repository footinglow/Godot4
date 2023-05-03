extends StaticBody3D

@export var m_i_island_num_min : int = 2
@export var m_i_island_num_max : int = 6

@export var m_d_island_size_min : float = 6.0
@export var m_d_island_size_max : float = 15.0

@export var m_d_next_dir_min : float = 0.0
@export var m_d_next_dir_max : float = 180.0

@export var m_d_path_min : float = 5
@export var m_d_path_max : float = 20

@export var m_d_path_width_min : float = 1.0
@export var m_d_path_width_max : float = 2.0

var m_r2_islands = null
var m_v3_path_pos = null


# 三角形２つで四角形を作る
# l:Left, t:Top, r:Right, b:bottom
func add_square(vertices, normals, x_l, z_t, x_r, z_b):
	vertices.push_back(Vector3(x_l, 0, z_t))
	vertices.push_back(Vector3(x_r, 0, z_t))
	vertices.push_back(Vector3(x_r, 0, z_b))
	normals.push_back(Vector3.UP)
	normals.push_back(Vector3.UP)
	normals.push_back(Vector3.UP)

	vertices.push_back(Vector3(x_r, 0, z_b))
	vertices.push_back(Vector3(x_l, 0, z_b))
	vertices.push_back(Vector3(x_l, 0, z_t))
	normals.push_back(Vector3.UP)
	normals.push_back(Vector3.UP)
	normals.push_back(Vector3.UP)

# ステージ生成する
func create_map():
	m_r2_islands = Array()
	m_v3_path_pos = Array()
	


	var i_island_num = randi_range(m_i_island_num_min, m_i_island_num_max)	# from,to含む乱数

	var d_x_m = 0.0
	var d_y_m = 0.0
	var pre_r : Rect2
	for i in range(i_island_num):
		# Islandを生成する
		var r : Rect2 = Rect2()
		r.size.x = randf_range(m_d_island_size_min, m_d_island_size_max)
		r.size.y = r.size.x
		r.position.x = -r.size.x / 2.0
		r.position.y = -r.size.y / 2.0

		# 2番目以降の島の場合、前の島との距離情報を使って移動する
		if i > 0:
			# Islandの向きとパスの長さを決定する
			var d_dir_deg = randf_range(m_d_next_dir_min, m_d_next_dir_max)
			var d_path_len = randf_range(m_d_path_min, m_d_path_max)

			# 島と島の中心の距離を計算する（半径＋path長＋半径）
			var d_len_m = ( pre_r.size.x /2.0 ) + d_path_len + (r.size.x / 2.0)
			d_x_m += cos( deg_to_rad(d_dir_deg) ) * d_len_m 
			d_y_m += sin( deg_to_rad(d_dir_deg) ) * d_len_m 
			r.position.x = d_x_m
			r.position.y = d_y_m

			# Pathを作る
			create_path(pre_r, r, d_dir_deg, d_path_len)
		
		# 島を追加
		m_r2_islands.append(r)

		# 前の島として保存する
		pre_r = r

func create_path(pre_r : Rect2, r : Rect2, d_dir_deg : float, d_path_len : float):
	print("pre_r:", pre_r, ", r:", r, ", d_dir_deg:", d_dir_deg, ", d_path_len:", d_path_len)
	
	# 道幅を決める
	var d_path_w = randf_range(m_d_path_width_min, m_d_path_width_max)
	
	# パスの入り口出口を決める。Floorの上面と下面を接続する
	var d_pre_path_x = randf_range(d_path_w, pre_r.size.x - d_path_w)
	var d_next_path_x = randf_range(d_path_w, r.size.x - d_path_w)

	# Path点列の初期化
	var v3_pre_pos = Vector3(
						pre_r.position.x + d_pre_path_x,
						0.0,
						pre_r.position.y + pre_r.size.y)
	var v3_next_pos = Vector3(
						r.position.x + d_next_path_x,
						0.0,
						r.position.y)

	print("v3_pre_pos:", v3_pre_pos)
	print("v3_next_pos:", v3_next_pos)

	$Path3D.curve.clear_points()
	$Path3D.curve.point_count = 2	# 入り口と出口の2点を設定する
	$Path3D.curve.add_point(Vector3.ZERO, Vector3.ZERO, Vector3(0, 0, d_path_len))
	$Path3D.curve.add_point(v3_next_pos - v3_pre_pos, Vector3(0, 0, -d_path_len), Vector3.ZERO)
	
	var max : float = roundf(d_path_len)
	for i in range(max+1):								# int型で丸める。10mの場合、0,1,2,...10まで回したい
		$Path3D/PathFollow3D.progress_ratio = i / max 	# 10で割ると１になる
		m_v3_path_pos.append(v3_pre_pos + $Path3D/PathFollow3D.position)
		print("progress_ratio:", $Path3D/PathFollow3D.progress_ratio, ", position:", $Path3D/PathFollow3D.position)

# ArrayMeshでマップを作成する
func create_mesh():
	var vertices = PackedVector3Array()
	var normals  = PackedVector3Array()

	for r in m_r2_islands:
		add_square(vertices, normals, r.position.x, r.position.y, r.position.x + r.size.x, r.position.y + r.size.y)

	for pos in m_v3_path_pos:
		add_square(vertices, normals, pos.x - 0.5, pos.z - 0.5, pos.x + 0.5, pos.z + 0.5)
	
	var arrays = Array()
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_NORMAL] = normals

	var tmpMesh = ArrayMesh.new()
	tmpMesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	$StageFloor.mesh = tmpMesh
	
	# MeshからCollision形状(ConcavePolygonShape3D)生成
	$CollisionShape3D.shape = tmpMesh.create_trimesh_shape()

func debug_draw_line():
	var vertices = PackedVector3Array()

	var pre_pos = Vector3.ZERO
	var f_is_first = true
	for pos in m_v3_path_pos:
		if f_is_first :
			f_is_first = false
		else:
			vertices.push_back(Vector3(pre_pos.x, 0, pre_pos.z))
			vertices.push_back(Vector3(pos.x, 0, pos.z))

		pre_pos = pos
	
	var arrays = Array()
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices

	var tmpMesh = ArrayMesh.new()
	tmpMesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
	$Debug/PathLine.mesh = tmpMesh
	
func _ready():
	create_map()
	create_mesh()
	debug_draw_line()

