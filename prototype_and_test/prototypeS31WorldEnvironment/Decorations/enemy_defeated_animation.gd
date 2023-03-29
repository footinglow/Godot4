extends Node3D

func animation_play(name):
	$AnimationPlayer.play(name)

func _on_animation_player_animation_finished(anim_name):
	queue_free()
