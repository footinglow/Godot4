extends Control

# タッチドラッグ位置
var f_diplay_drag_pos = false
var m_v2_touch_pos = Vector2.ZERO
var m_v2_drag_pos = Vector2.ZERO

func _process(delta):
	queue_redraw()

func _draw():
	# ドラッグ量の可視化
	if g_c_.m_ui_kind == g_c_.UI_KIND.TOUCH_PAD:	
		if f_diplay_drag_pos:
			# UI表示
			var circle_pos = m_v2_drag_pos
			if (m_v2_drag_pos-m_v2_touch_pos).length() >= g_c_.m_d_ui_max_px_len:
				var rad = atan2(m_v2_drag_pos.y - m_v2_touch_pos.y, m_v2_drag_pos.x - m_v2_touch_pos.x)
				circle_pos = m_v2_touch_pos + Vector2(cos(rad), sin(rad)) * g_c_.m_d_ui_max_px_len
			draw_circle(m_v2_touch_pos, g_c_.m_d_ui_max_px_len + g_c_.m_d_design_ctrl_circle_r, Color(1, 1, 1, 0.2))
			draw_circle(circle_pos,   g_c_.m_d_design_ctrl_circle_r, Color(1, 1, 1, 0.5))

			f_diplay_drag_pos = false
		else:
			pass	# タッチしていないときは更新しない
	else:
		# タッチパッド以外は表示不要
		pass	
			

func _on_game_sig_to_hud_drag_line(touch_pos, drag_pos):
	m_v2_touch_pos = touch_pos
	m_v2_drag_pos = drag_pos
	f_diplay_drag_pos = true
