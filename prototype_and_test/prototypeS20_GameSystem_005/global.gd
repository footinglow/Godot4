extends Node

enum EN_GLOBAL_SCENE {
	TITLE,
	PLAY,
}

func goto_scene(en_globalscene):
	call_deferred("_deferred_goto_scene", en_globalscene)

func _deferred_goto_scene(en_globalscene):
	match en_globalscene:
		EN_GLOBAL_SCENE.TITLE:
			get_tree().change_scene_to_file("res://title.tscn")
		EN_GLOBAL_SCENE.PLAY:
			get_tree().change_scene_to_file("res://game_system.tscn")
			
