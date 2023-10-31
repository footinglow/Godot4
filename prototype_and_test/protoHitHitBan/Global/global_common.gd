extends Node


# 操作方法パラメータ
enum UI_KIND {
	TOUCH_PAD,
}
var m_ui_kind : UI_KIND = UI_KIND.TOUCH_PAD

# TOUCH AND GO
var m_v2_ui_center_pos = Vector2( 350, 750 )
var m_d_ui_max_px_len = 100		# ドラッグ長の最大。

var m_d_design_ctrl_circle_r = 30.0
var m_v2_ui_player_pos = Vector2( 500/2, 900/2 )

