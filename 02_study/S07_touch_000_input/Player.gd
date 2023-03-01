extends CharacterBody3D

var m_touch_pos = Vector2.ZERO

func _input(event):
	if ( event is InputEventScreenDrag ) or ( event is InputEventScreenTouch ):
		m_touch_pos = event.position
		print("m_touch_pos:", m_touch_pos)
