extends Node3D

# デバイス座標系の重力の向きをGodot座標系の重力の向きに変更する
func get_gravity_on_godot_axes() -> Vector3:
	# 重力センサーの値を取得
	var v3_g_dir_dev = Input.get_gravity()
	
	var v3_g_dir = Vector3.ZERO
	v3_g_dir.x = v3_g_dir_dev.x
	v3_g_dir.y = v3_g_dir_dev.z
	v3_g_dir.z = -v3_g_dir_dev.y

	return v3_g_dir

func _physics_process(delta):
	# 重力の方向を取得
	var g : Vector3 = get_gravity_on_godot_axes()

	# 現在のノードxの角度をオイラー角[rad]で取得する。インスペクタのNode3D/Transform/Rotationの値
	var v3_x_rot : Vector3 =  $x.transform.basis.get_euler()
	# 重力センサー値から重力方向角度を計算する
	var x_rad = atan2(g.z, g.y) + PI
	# 重力の方向を打ち消す方向（スマホを傾けた方向）を目標角度として現在の角度との差分を回線指示する
	$x.rotate_x( -x_rad - v3_x_rot.x )

	# x軸の回転と同じ
	var v3_z_rot : Vector3 = $x/z.transform.basis.get_euler()
	var z_rad = atan2(g.y, g.x) + PI/2
	$x/z.rotate_z( -z_rad - v3_z_rot.z)
