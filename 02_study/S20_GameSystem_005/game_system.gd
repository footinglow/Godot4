extends Node3D

enum EN_GAME_STS {
	READY,
	IN_PLAY,
	STAGE_CLEAR,
	STAGE_FAILED,
}
var m_en_game_sts = EN_GAME_STS.READY

# ステージシーンリスト（PackedScene型）
var m_nodearray_stages = [
	preload("res://Stages/stage001.tscn"),
	preload("res://Stages/stage002.tscn"),
	preload("res://Stages/stage003.tscn"),
]

# 現在実行中のステージ番号
var m_i_current_stage_idx = 0

# タッチイベント処理
var m_f_touch = false

func _input(event):
	if ( event is InputEventScreenTouch ) and event.pressed:
		m_f_touch = true
			
func set_new_stage(idx):
	# CurrentStageにあるステージをすべて削除する
	var nodes = $CurrentStage.get_children()
	for node in nodes:
		node.queue_free()
	# idx番目のステージシーンのインスタンスを生成して、CurrentStageに追加する
	var new_stage = m_nodearray_stages[idx].instantiate()
	$CurrentStage.add_child(new_stage)

func hide_all_messages():
	# メッセージを表示をすべて隠す
	var nodes = $Messages.get_children()
	for node in nodes:
		node.hide()
		
func _ready():
	set_new_stage(m_i_current_stage_idx)

func _physics_process(delta):
	match m_en_game_sts :
		EN_GAME_STS.READY:
			# 画面タッチされたら、Ready表示を刑してプレイ中にする
			if m_f_touch:
				hide_all_messages()
				m_en_game_sts = EN_GAME_STS.IN_PLAY
				# "GameControl"グループを持つ、PlayerとEnemyのスクリプトのgame_start()メソッドを起動する
				get_tree().call_group("StartStopControl", "game_start")
				# 「Go」を表示して２秒後にメッセージを消す
				$Messages/Go.show()
				await get_tree().create_timer(2.0).timeout
				hide_all_messages()
		EN_GAME_STS.IN_PLAY:
			var nodes = $CurrentStage.get_children()
			if nodes:
				# nodesは1個か0個のどちらかなので、0番目を固定的に使用する
				if nodes[0].is_stage_clear():
					# ゲーム状態を「ステージクリア」状態にして「Stage Clear」を表示
					m_en_game_sts = EN_GAME_STS.STAGE_CLEAR
					hide_all_messages()
					$Messages/StageClear.show()
				if nodes[0].is_stage_failed():
					# ゲーム状態を「ステージ失敗」状態にして「Stage Failed」を表示
					m_en_game_sts = EN_GAME_STS.STAGE_FAILED
					hide_all_messages()
					$Messages/StageFailed.show()
		EN_GAME_STS.STAGE_CLEAR:
			# 画面タッチされたら、Readyに遷移する
			if m_f_touch:					
				# 次のステージに進む
				m_i_current_stage_idx = ( m_i_current_stage_idx + 1 ) % m_nodearray_stages.size()
				set_new_stage(m_i_current_stage_idx)
				# ゲーム状態を「レディ」状態にして、「Ready」を表示する
				m_en_game_sts = EN_GAME_STS.READY
				hide_all_messages()
				$Messages/Ready.show()
		EN_GAME_STS.STAGE_FAILED:
			# 画面タッチされたら、Readyに遷移する
			if m_f_touch:
				Global.goto_scene("res://title.tscn")
	# _physics_process()の最後にm_f_touchフラグを落とす
	m_f_touch = false
