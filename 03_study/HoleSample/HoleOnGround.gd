extends StaticBody3D

#
# カーソルキー操作でhole（落とし穴）を動かす
#
const SPEED = 3.0

# 地面の大きさ
var m_d_ground_w_m : float = 20.0
var m_d_ground_d_m : float = 20.0

# 落とし穴
var m_v3_hole_pos = Vector3(0, 0, 0)
var m_d_hole_x_m : float = 1.0
var m_d_hole_z_m : float = 1.0

func _physics_process(delta):
	var velocity = Vector3.ZERO
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x
		velocity.z = direction.z

	# holeの位置を移動
	m_v3_hole_pos += velocity.normalized() * SPEED * delta
	set_hole_and_ground_array_mesh()
	
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
	

# 落とし穴ArrayMeshを作成する
func set_hole_and_ground_array_mesh():

	var vertices = PackedVector3Array()
	var normals  = PackedVector3Array()
	# 地面のXZ平面上の左上、右下の位置を設定
	var ground_LT = Vector3(-m_d_ground_w_m/2.0 , 0, -m_d_ground_d_m/2.0)
	var ground_RB = Vector3( m_d_ground_w_m/2.0 , 0,  m_d_ground_d_m/2.0)
	# holeのXZ平面上の左上、右下の位置を設定
	var hole_size = Vector3( m_d_hole_x_m , 0,  m_d_hole_z_m)
	var hole_LT = m_v3_hole_pos - hole_size/2.0
	var hole_RB = m_v3_hole_pos + hole_size/2.0

	# 3×３グリッドの上３ブロック
	add_square(vertices, normals, ground_LT.x, ground_LT.z ,ground_RB.x, hole_LT.z)
	# 3×３グリッド、左（holeの左）
	add_square(vertices, normals, ground_LT.x, hole_LT.z ,hole_LT.x, hole_RB.z)
	# 3×３グリッド、右（holeの右）
	add_square(vertices, normals, hole_RB.x, hole_LT.z ,ground_RB.x, hole_RB.z)
	# 3×３グリッドの下３ブロック
	add_square(vertices, normals, ground_LT.x, hole_RB.z ,ground_RB.x, ground_RB.z)
	
	var arrays = Array()
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_NORMAL] = normals

	var tmpMesh = ArrayMesh.new()
	tmpMesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	$MeshInstance3D.mesh = tmpMesh
	
	# MeshからCollision形状(ConcavePolygonShape3D)生成
	$CollisionShape3D.shape = tmpMesh.create_trimesh_shape()
