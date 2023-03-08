extends Node3D

func _physics_process(delta):
	if $CurrentStage/Stage.is_stage_clear():
		print("Stage Clear")

	if $CurrentStage/Stage.is_stage_failed():
		print("Stage Failed")
