extends Control

func _ready():
	$HSlider.value = GlobalConfig.m_firing_timing_sec * 10
	_on_h_slider_drag_ended(true)
	
func _on_h_slider_drag_ended(value_changed):
	$FiringTiming.text = "発射間隔 %.1f秒" % ($HSlider.value/10)
	
func _on_close_button_pressed():
	GlobalConfig.m_firing_timing_sec = $HSlider.value/10
	GlobalConfig.save()
	Global.goto_scene("res://title.tscn")
