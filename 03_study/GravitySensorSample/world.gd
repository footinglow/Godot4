extends Node3D

func _physics_process(delta):
	# 重力センサーの値を取得
	var v3_graviry_dir_on_dev = Input.get_gravity()
	
	# Godotの座標系に変換する
	var v3_gravity_dir_on_godot = Vector3.ZERO
	v3_gravity_dir_on_godot.x = v3_graviry_dir_on_dev.x
	v3_gravity_dir_on_godot.y = v3_graviry_dir_on_dev.z
	v3_gravity_dir_on_godot.z = -v3_graviry_dir_on_dev.y
	
	# 重力方向が正面となるようにノードの向きを設定する
	$MeshInstance3D.look_at(v3_gravity_dir_on_godot, Vector3.UP)
