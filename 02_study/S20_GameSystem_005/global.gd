extends Node

func goto_scene(scene_path):
	call_deferred("_deferred_goto_scene", scene_path)

func _deferred_goto_scene(scene_path):
	get_tree().change_scene_to_file(scene_path)
