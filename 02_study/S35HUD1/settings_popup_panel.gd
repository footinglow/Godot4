extends PopupPanel

func open():
	get_tree().paused = true
	popup_centered()
	$ControlBaseSize/VBoxContainer/MarginContainer2/HSlider.value = GlobalSettings.m_firing_timing_sec
	_on_h_slider_drag_ended(true)

func _on_h_slider_drag_ended(value_changed):
	$ControlBaseSize/VBoxContainer/MarginContainer/Label.text = "発射間隔 %.1f秒" % $ControlBaseSize/VBoxContainer/MarginContainer2/HSlider.value

func _on_button_pressed():
	GlobalSettings.m_firing_timing_sec = $ControlBaseSize/VBoxContainer/MarginContainer2/HSlider.value
	GlobalSettings.save()
	hide()

func _on_popup_hide():
	get_tree().paused = false
