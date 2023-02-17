extends Area3D


var v_direction = Vector3(0.5, 0.5, 0.0)
var d_speed_mps = 2.0	# m/s
var d_speed_degs = 90.0	# degree/sec

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# v_directionの方向に異動する
	transform.origin += v_direction.normalized() * d_speed_mps * delta
	print(transform.origin)
	
	# X軸周りを回転する
	rotate_x( deg_to_rad(d_speed_degs) * delta )

