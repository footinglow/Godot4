extends Node3D

# ステージシーンリスト（PackedScene型）
var m_nodearray_stages = [
	preload("res://Stages/stage001.tscn"),
	preload("res://Stages/stage002.tscn"),
	preload("res://Stages/stage003.tscn"),
]

# 現在実行中のステージ番号
var m_i_current_stage_idx = 0

func set_new_stage(idx):
	# CurrentStageにあるステージをすべて削除する
	var nodes = $CurrentStage.get_children()
	print(nodes)
	for node in nodes:
		node.queue_free()
	# idx番目のステージシーンのインスタンスを生成して、CurrentStageに追加する
	var new_stage = m_nodearray_stages[idx].instantiate()
	$CurrentStage.add_child(new_stage)

func _ready():
	set_new_stage(m_i_current_stage_idx)
	
func _physics_process(delta):
	var nodes = $CurrentStage.get_children()
	if nodes:
		# nodesは1個か0個のどちらかなので、0番目を固定的に使用する
		if nodes[0].is_stage_clear():
			print("Stage Clear")
			# ステージは0,1,2,0,1,2,0...と繰り返す
			m_i_current_stage_idx = ( m_i_current_stage_idx + 1 ) % m_nodearray_stages.size()
			set_new_stage(m_i_current_stage_idx)

		if nodes[0].is_stage_failed():
			print("Stage Failed")
			set_new_stage(m_i_current_stage_idx)
