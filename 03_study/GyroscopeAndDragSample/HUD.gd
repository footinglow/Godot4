extends Control

func _process(delta):
	queue_redraw()

func _draw():
	draw_line($"../World".m_touch_pos, $"../World".m_drag_pos,Color.YELLOW,5.0, true)
