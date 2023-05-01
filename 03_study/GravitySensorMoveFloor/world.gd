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
	var g = get_gravity_on_godot_axes()

	# ノードの向きを初期化する（インスペクタのNode3D/Transform/Rotationを(0,0,0)にする
	$x.look_at(Vector3.FORWARD, Vector3.UP)
	$x/z.look_at(Vector3.FORWARD, Vector3.UP)

	# 重力センサーの値に従って回転する
	var x_rad = atan2(g.y, -g.z) + PI/2
	$x.rotate_x( -x_rad )
	var z_rad = atan2(g.y, g.x) + PI/2
	$x/z.rotate_z( -z_rad )
