extends Area3D

var v_direction = Vector3(0.0, 0.0, -1.0)
var d_speed_mps = 2.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	transform.origin += v_direction.normalized() * d_speed_mps * delta
	
