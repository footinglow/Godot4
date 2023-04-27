extends Area3D


var m_node_player
var m_v3_pre_player_pos = Vector3.ZERO
var m_d_pre_player_deg = 0.0
func _ready():
	m_node_player = $"../MyBall"

func _physics_process(delta):
	# 現在のPlayerの角度を計算する
	var dir = m_node_player.transform.origin - transform.origin
	var rad = atan2(-dir.z, dir.x)
	var deg = rad_to_deg(rad)

	# 今回の角度が前回の角度より時計回り方向であることを確認する
	var diff_deg = deg - m_d_pre_player_deg
	var c_diff_deg = diff_deg
	if absf(diff_deg) > 180:
		c_diff_deg -= 360.0
	elif absf(diff_deg) < -180:
		c_diff_deg += 360.0
	else:
		pass

	if absf(c_diff_deg) < absf(diff_deg):
		diff_deg = c_diff_deg 
	else:
		pass
		
	# 時計回り方向の場合と逆方向の場合で色を変更する
	var material : StandardMaterial3D = $area.mesh.surface_get_material(0)
	if diff_deg < 0:
		# 時計回りなのでOK
		material.albedo_color = Color.GREEN
	else :
		material.albedo_color = Color.RED

	# 前回値として保存する
	m_d_pre_player_deg = deg;
	m_v3_pre_player_pos = m_node_player.transform.origin
	
