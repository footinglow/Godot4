extends CharacterBody3D

var v_direction = Vector3(0.0, 0.0, -1.0)
var d_speed_mps = 1.0

func _ready():
	velocity = v_direction * d_speed_mps
	
func _physics_process(delta):
	move_and_collide(velocity*delta)
