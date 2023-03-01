extends CharacterBody3D

func _ready():
	velocity = Vector3(0.0, 0.0, -1.0) 

func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta)
	velocity = Vector3(0.0, 0.0, -1.0) 
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
#	print(velocity)

