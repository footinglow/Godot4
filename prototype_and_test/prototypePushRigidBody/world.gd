extends Node3D


var m_touch_pos = Vector2.ZERO		# タッチした時の位置
var m_drag_pos = Vector2.ZERO		# 現在のタッチ位置・ドラッグ位置
var m_f_is_screen_touch = false		# スクリーンにタッチ（ドラッグ含む）している場合true

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
		if m_touch_pos == Vector2.ZERO:
			# READY状態にタッチするとWorldが動き出すため最初のタッチが検知されないためここで初期値を設定する
			m_touch_pos = event.position
		m_drag_pos = event.position
		m_f_is_screen_touch = true


func _physics_process(delta):
	if m_f_is_screen_touch:
		# 上下ドラッグ量を回転量に変換する
		if (m_drag_pos.y - m_touch_pos.y) < 0:
			$RigidBody3D.apply_torque(Vector3.DOWN)
		else:
			$RigidBody3D.apply_torque(Vector3.UP)
		
		# X軸方向に力を加える
		var d_acc_x = (m_drag_pos.x - m_touch_pos.x) / 10.0
		d_acc_x = clampf(d_acc_x, -10.0, 10.0)
		$RigidBody3D.apply_central_force(Vector3(d_acc_x,0,0))

func _on_area_3d_body_entered(body):
	#body.apply_central_force(Vector3(-100,0,0))
	body.apply_central_impulse(Vector3(-10,0,0))
