extends Node3D

var m_i_radial_segments_num = 6		# 六角錐の６
var m_d_radius_m = 3.0				# 半径
var m_d_height_m = 3.0				# 高さ

func _ready():
	var vertices = PackedVector3Array()
	var normals = PackedVector3Array()

	# 1周分の角度をアジアンでリストに保存する。最後にスタート地点の0°を追加する
	var d_rad_list = Array()
	for i in range(m_i_radial_segments_num):
		var rate = float(i) / float(m_i_radial_segments_num)
		d_rad_list.push_back( 2.0 * PI * rate )
	d_rad_list.push_back(0.0)
	
	# 三角形を追加する
	for i in range(m_i_radial_segments_num):
		var a = Vector3(0, 0, m_d_height_m)
		var b = Vector3(cos(d_rad_list[i  ]) * m_d_radius_m, sin(d_rad_list[i  ]) * m_d_radius_m, 0)
		var c = Vector3(cos(d_rad_list[i+1]) * m_d_radius_m, sin(d_rad_list[i+1]) * m_d_radius_m, 0)
		# 配列には頂点a,c,bの順番に格納する
		vertices.push_back(a)
		vertices.push_back(c)
		vertices.push_back(b)

		# 法線を原点x,y,z)=0,0,0)から放射状に設定する
		normals.push_back(a.normalized())
		normals.push_back(c.normalized())
		normals.push_back(b.normalized())
		
		#　外積で法線を求める
		#var ab = b - a
		#var ac = c - a
		#var normal = ab.cross(ac)
		#normals.push_back(normal)
		#normals.push_back(normal)
		#normals.push_back(normal)
		
	var arrays = Array()
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_NORMAL] = normals

	var tmpMesh = ArrayMesh.new()
	tmpMesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	$ArrayMesh.mesh = tmpMesh
	
	# メッシュをファイルに保存する
	ResourceSaver.save(tmpMesh, "res://hexagonal_pyramid.tres", ResourceSaver.FLAG_COMPRESS)
