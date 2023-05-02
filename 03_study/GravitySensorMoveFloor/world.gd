extends Node3D

func _physics_process(delta):
	# 重力加速度を取得。スマホデバイス座標系
	var g : Vector3 = Input.get_gravity()

	# 現在のノードxの角度をオイラー角[rad]で取得する。インスペクタのNode3D/Transform/Rotationの値(をラジアンで表したもの）
	var v3_x_rot : Vector3 =  $x.transform.basis.get_euler()
	# 重力センサー値（加速度）をベクトルに見立てて、床の(Godot座標系の)目標角度を計算する
	var x_rad = -atan2(g.z, g.y) - PI/2
	# 目標角度と現在の角度との差分を回転するように指示する
	$x.rotate_x( x_rad - v3_x_rot.x )

	# 考え方はx軸の回転と同じ
	var v3_z_rot : Vector3 = $x/z.transform.basis.get_euler()
	var z_rad = -atan2(g.z, g.x) - PI/2	# g.z, g.xはデバイス座標系、z_radはGodot座標系
	$x/z.rotate_z( z_rad - v3_z_rot.z)
