extends Control

func _on_button_pressed():
	Global.goto_scene("res://game_system.tscn")

func _on_settings_button_pressed():
	$SettingsPopupPanel.open()
