extends Node2D

func _physics_process(delta):
	set_energr_bar_mesh()
	
	
func set_energr_bar_mesh():
	# 三角形を描画する
	var vertices = PackedVector2Array()
		
	vertices.push_back( Vector2(0, 0) )
	vertices.push_back( Vector2(500, 900) )
	vertices.push_back( Vector2(0, 900) )

	var tmpMesh = ArrayMesh.new()
	var arrays = Array()
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	tmpMesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	$EnergyBar.mesh = tmpMesh
	
