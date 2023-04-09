extends StaticBody3D


const SPEED = 3.0


func _physics_process(delta):
	var velocity = Vector3.ZERO
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	transform.origin += velocity.normalized()*SPEED*delta

	set_hole_and_ground_array_mesh(transform.origin.x, transform.origin.z)
	


var m_d_ground_w_m : float = 20.0
var m_d_ground_d_m : float = 20.0
var m_v3_hole_pos = Vector3(0, 0, 0)
var m_d_hole_x_m : float = 1.0
var m_d_hole_z_m : float = 1.0




func add_square(vertices : PackedVector3Array, x_l, z_t, x_r, z_b):
	vertices.push_back(Vector3(x_l, 0, z_t))
	vertices.push_back(Vector3(x_r, 0, z_t))
	vertices.push_back(Vector3(x_r, 0, z_b))

	vertices.push_back(Vector3(x_r, 0, z_b))
	vertices.push_back(Vector3(x_l, 0, z_b))
	vertices.push_back(Vector3(x_l, 0, z_t))
	

func set_hole_and_ground_array_mesh(x, z):
	m_v3_hole_pos.x = x
	m_v3_hole_pos.z = z
	
	
	var vertices = PackedVector3Array()

	# holeの左上、右下の位置を計算
	var ground_LT = m_v3_hole_pos - Vector3(-m_d_ground_w_m/2.0 , 0, -m_d_ground_d_m/2.0)
	var ground_RB = m_v3_hole_pos - Vector3( m_d_ground_w_m/2.0 , 0,  m_d_ground_d_m/2.0)
	var hole_LT = m_v3_hole_pos - Vector3(-m_d_hole_x_m/2.0 , 0, -m_d_hole_z_m/2.0)
	var hole_RB = m_v3_hole_pos - Vector3( m_d_hole_x_m/2.0 , 0,  m_d_hole_z_m/2.0)

	# 3×３グリッドの上３ブロック
	add_square(vertices, ground_LT.x, ground_LT.z ,ground_RB.x, hole_LT.z)
	# 3×３グリッド、左（holeの左）
	add_square(vertices, ground_LT.x, hole_LT.z ,hole_LT.x, hole_RB.z)
	# 3×３グリッド、右（holeの右）
	add_square(vertices, hole_RB.x, hole_LT.z ,ground_RB.x, hole_RB.z)
	# 3×３グリッドの下３ブロック
	add_square(vertices, ground_LT.x, hole_RB.z ,ground_RB.x, ground_RB.z)
	
	var arrays = Array()
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices

	var tmpMesh = ArrayMesh.new()
	tmpMesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	$MeshInstance3D.mesh = tmpMesh
	
	# MeshからCollision形状(ConcavePolygonShape3D)生成
	$CollisionShape3D.shape = tmpMesh.create_trimesh_shape()
