extends PopupPanel

func open():
	get_tree().paused = true
	popup_centered()

func _on_h_slider_drag_ended(value_changed):
	print($ControlBaseSize/VBoxContainer/HSlider.value)
	$ControlBaseSize/VBoxContainer/Label.text = "発射間隔 %.1f秒" % $ControlBaseSize/VBoxContainer/HSlider.value

func _on_button_pressed():
	hide()

func _on_popup_hide():
	get_tree().paused = false
