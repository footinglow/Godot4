extends Node3D

# Player
@export var m_speed_mps = 3.0
@export var m_scn_laser : PackedScene
@export var m_firing_interval_sec = 0.2

var m_firing_remain_time_sec = 0

# ドラッグ操作検知用
var m_touch_pos = Vector2.ZERO		# タッチした時の位置
var m_drag_pos = Vector2.ZERO		# 現在のタッチ位置・ドラッグ位置
var m_f_is_screen_touch = false		# スクリーンにタッチ（ドラッグ含む）している場合true

# DRAG_TO_MOVEドラッグした分移動する操作方法）の時用
var m_v_base_player_pos = Vector3.ZERO


func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			# タッチしたところを初期位置として記憶する
			m_touch_pos  = event.position
			m_drag_pos = event.position
			m_f_is_screen_touch = true
			# m_touch_posを設定したときのプレイヤーの位置を基準として記憶する
			m_v_base_player_pos = $player.global_position
		else:
			# 指を離したのを検知する
			m_f_is_screen_touch = false
	elif event is InputEventScreenDrag:
		if m_touch_pos == Vector2.ZERO:
			# READY状態にタッチするとWorldが動き出すため最初のタッチが検知されないためここで初期値を設定する
			m_touch_pos = event.position
			# m_touch_posを設定したときのプレイヤーの位置を基準として記憶する
			m_v_base_player_pos = $player.global_position
		m_drag_pos = event.position
		m_f_is_screen_touch = true


func _physics_process(delta):
	if m_f_is_screen_touch:
		# ドラッグ開始位置と、現在の位置を3D空間上の大体の位置に変換する
		# 斜めに見下ろしている構図の場合、project_positionのZposには、カメラのY座標と角度からcosで割った値を設定する
		# またスマホの手前のZposより奥のZposの方が長いので、タッチ座標のYの位置によってもproject_positionのZposの計算が必要
		var camera = get_viewport().get_camera_3d()
		var v_touch_pos = camera.project_position(m_touch_pos, camera.global_position.y)
		var v_drag_pos  = camera.project_position(m_drag_pos,  camera.global_position.y)
		v_touch_pos.y = 0	# Y軸方向には移動しないので０にする
		v_drag_pos.y = 0	# Y軸方向には移動しないので０にする
		
		# ３D空間の移動先目標位置
		var v_target_pos = m_v_base_player_pos + ( v_drag_pos - v_touch_pos )
		
		# delta時間で目標位置に移動できる速度を設定してmove_and_slideする（本当はPlayerシーン内でやるべき）
		$player.velocity =  (v_target_pos - $player.global_position ) / delta
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
		
	else:
		pass
