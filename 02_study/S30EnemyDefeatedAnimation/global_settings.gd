extends Node

var m_firing_timing_sec = 1.0

const M_FILE_NAME = "user://config.cfg"

func _ready():
	# ConfigFile生成
	var config = ConfigFile.new()
	# ファイルから読み出し
	var err = config.load(M_FILE_NAME)
	# エラーの場合終了（最初の軌道の場合はファイルがない）
	if err != OK:
		return
	# クション"Player"のキー"firing_timing"に対する値を読み出す
	m_firing_timing_sec = config.get_value("Player", "firing_timing")

func save():
	# ConfigFile生成
	var config = ConfigFile.new()
	# セクション"Player"のキー"firing_timing"に対して、m_firing_timing_secを保存する
	config.set_value("Player", "firing_timing", m_firing_timing_sec)

	# ファイルに保存する (上書き).
	config.save(M_FILE_NAME)
