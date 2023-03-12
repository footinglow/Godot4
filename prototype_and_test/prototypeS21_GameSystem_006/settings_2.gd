extends Window

func open():
	$Control/VBoxContainer/HSlider.value = GlobalConfig.m_firing_timing_sec * 10
	_on_h_slider_drag_ended(true)
	popup_centered()
	
func _on_button_pressed():
	print("_on_button_pressed")
	GlobalConfig.m_firing_timing_sec = $Control/VBoxContainer/HSlider.value/10
	GlobalConfig.save()
	hide()

func _on_popup_hide():
	print("_on_popup_hide")
	get_tree().paused = false

	
func _on_h_slider_drag_ended(value_changed):
	$Control/VBoxContainer/Label.text = "発射間隔 %.1f秒" % ($Control/VBoxContainer/HSlider.value/10)
	


