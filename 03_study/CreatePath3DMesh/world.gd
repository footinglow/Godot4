extends Node3D

var m_scn_red = preload("res://point_red.tscn")
var m_scn_blue = preload("res://point_blue.tscn")

@export var m_d_path_width  : float = 0.5	# 道の幅
@export var m_d_path_devide : float = 100.0	# 道を四角形に分割する数。大きいほど道がなめらかになります。

var m_v3_path_lefts = []
var m_v3_path_rights = []

func _ready():
	create_path($Path3D/PathFollow3D)
	create_path_mesh($MeshInstance3D)

func create_path(node_pf : PathFollow3D):
	# 道幅を設定
	var node_left : Marker3D = node_pf.get_node("left")
	var node_right : Marker3D = node_pf.get_node("right")
	node_left.transform.origin.x = -m_d_path_width / 2.0
	node_right.transform.origin.x = m_d_path_width / 2.0
	
	# マーカー追加する
	for i in range(m_d_path_devide+1):
		node_pf.progress_ratio = i /m_d_path_devide 

		var l_pos = node_pf.transform * node_left.position
		m_v3_path_lefts.append(l_pos)
		var r_pos = node_pf.transform * node_right.position
		m_v3_path_rights.append(r_pos)
		
		var red = m_scn_red.instantiate()
		red.position = l_pos
		add_child(red)
		var blue = m_scn_blue.instantiate()
		blue.position = r_pos
		add_child(blue)

func create_path_mesh(node_mesh : MeshInstance3D):
	var vertices = PackedVector3Array()
	var normals  = PackedVector3Array()

	var pre_v3_l = Vector3.ZERO
	var pre_v3_r = Vector3.ZERO
	var f_is_first = true
	for i in range(m_v3_path_lefts.size()):
		var v3_l = m_v3_path_lefts[i]
		var v3_r = m_v3_path_rights[i]
		if f_is_first :
			f_is_first = false
		else:
			vertices.push_back(pre_v3_r)
			vertices.push_back(pre_v3_l)
			vertices.push_back(v3_r)
			normals.push_back(Vector3.UP)
			normals.push_back(Vector3.UP)
			normals.push_back(Vector3.UP)

			vertices.push_back(v3_l)
			vertices.push_back(v3_r)
			vertices.push_back(pre_v3_l)
			normals.push_back(Vector3.UP)
			normals.push_back(Vector3.UP)
			normals.push_back(Vector3.UP)

		pre_v3_l = v3_l
		pre_v3_r = v3_r
	
	var arrays = Array()
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_NORMAL] = normals

	var tmpMesh = ArrayMesh.new()
	tmpMesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	node_mesh.mesh= tmpMesh
