extends Area3D

@export var m_i_magnification = 2.0		# 倍率

func _ready():
	$Label3D.text = "x%d" % m_i_magnification
