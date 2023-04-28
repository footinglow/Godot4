extends Node3D

@export var m_d_speed = 0.5		# 大きくすると床が傾きやすくなる

var m_touch_pos = Vector2.ZERO		# タッチした時の位置
var m_drag_pos = Vector2.ZERO		# 現在のタッチ位置・ドラッグ位置
var m_f_is_screen_touch = false		# スクリーンにタッチ（ドラッグ含む）している場合true

var m_d_x_deg = 0.0		# 現在の床のX軸角度（積算）
var m_d_z_deg = 0.0		# 現在の床のZ軸角度（積算）

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			# タッチしたところを初期位置として記憶する
			m_touch_pos  = event.position
			m_drag_pos = event.position
			m_f_is_screen_touch = true
		else:
			m_f_is_screen_touch = false
	elif event is InputEventScreenDrag:
		m_drag_pos = event.position
		m_f_is_screen_touch = true

func _physics_process(delta):
	# ジャイロセンサーによる床傾け
	var v3_gyro_rad = Input.get_gyroscope()
	$x/z.rotate_z( -v3_gyro_rad.y * delta)
	$x.rotate_x(  v3_gyro_rad.x * delta)

	# タッチ操作による床傾け
	if m_f_is_screen_touch:
		# タッチのX軸方向の操作で左右に傾けたいので、Z軸を回転する
		var diff_x_px = m_drag_pos.x - m_touch_pos.x	# スクリーン上のタッチ位置とドラッグ中の位置の差をピクセル量で計算
		var target_z_deg = -diff_x_px * m_d_speed		# ピクセル量を適当に目標角度に変換
		var move_z_deg = target_z_deg - m_d_z_deg		# 目標角度と積算している現在の角度との差を計算
		$x/z.rotate_z(  (deg_to_rad(move_z_deg) * delta) )	# 1秒間でその差を埋めるように傾ける
		m_d_z_deg += move_z_deg * delta					# 現在の角度に反映する
		
		# タッチのY軸方向の操作で手前億に傾けたいので、x軸を回転する
		var diff_y_px = m_drag_pos.y - m_touch_pos.y
		var target_x_deg = diff_y_px * m_d_speed
		var move_x_deg = target_x_deg - m_d_x_deg
		$x.rotate_x(  (deg_to_rad(move_x_deg) * delta) )
		m_d_x_deg += move_x_deg * delta
