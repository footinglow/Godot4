extends Node2D

func _on_area_2d_area_entered(area):
	$StateChart.send_event("enemy_entered")
