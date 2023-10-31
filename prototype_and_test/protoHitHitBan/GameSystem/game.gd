extends Node3D

signal sig_to_hud_drag_line(touch_pos, drag_pos)

# Player
@export var m_speed_mps = 3.0
@export var m_scn_laser : PackedScene
@export var m_firing_interval_sec = 0.2

var m_firing_remain_time_sec = 0

# ドラッグ操作で床を傾ける
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
		var v_dir = Vector3.ZERO
		if g_c_.m_ui_kind == g_c_.UI_KIND.TOUCH_PAD:	
			# 中心からタッチ位置の計算
			var diff_x_px = m_drag_pos.x - g_c_.m_v2_ui_center_pos.x
			var diff_y_px = m_drag_pos.y - g_c_.m_v2_ui_center_pos.y
			# 移動方向を設定
			v_dir = Vector3(diff_x_px, 0, diff_y_px).normalized()
		else:
			pass

		# Playerの移動	
		$player.velocity = v_dir * m_speed_mps
		$player.move_and_slide()
		
		# タイミングをとりながらlaser発射
		if m_firing_remain_time_sec > 0:
			# 発射間隔を待つ
			m_firing_remain_time_sec -= delta
		else:
			var scn : Area3D = m_scn_laser.instantiate()
			scn.set_pos($player.global_position)
			add_sibling(scn)
			# 発射間隔を設定
			m_firing_remain_time_sec = m_firing_interval_sec
		
		# HUDに送信
		sig_to_hud_drag_line.emit(g_c_.m_v2_ui_center_pos, m_drag_pos)
	else:
		# HUDに送信
		sig_to_hud_drag_line.emit(g_c_.m_v2_ui_center_pos, g_c_.m_v2_ui_center_pos)
