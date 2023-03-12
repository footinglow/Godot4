extends Control

func _on_button_pressed():
	Global.goto_scene("res://game_system.tscn")


func _on_config_button_pressed():
	# lobal.goto_scene("res://config_settings.tscn")
	
	get_tree().paused = true
	$Settings2.open()
