extends Node

# パラメータ
@export var m_d_energy_max : float = 100.0
@export var m_d_energy_min : float = 0.0
@export var m_d_energy_add : float = 5.0	# Bullet発射間隔が1秒の場合、20秒で100になる計算

# グローバル変数
var m_d_energy : float = 0.0

func increase_energy():
	m_d_energy = clampf(
				m_d_energy + m_d_energy_add,
				m_d_energy_min,
				m_d_energy_max
			)

func get_energy_percent() ->float:
	return m_d_energy / m_d_energy_max
