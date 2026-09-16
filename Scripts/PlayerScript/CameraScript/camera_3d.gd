extends Camera3D

@export var camera_tilt_val:float = 5
@export var max_tilt = 0.065
@export var target_tilt = 0.0

func camera_tilt(delta):
	var input_axis = Input.get_axis("left", "right")
	target_tilt = -input_axis * max_tilt
	rotation.z = lerp(rotation.z, target_tilt, camera_tilt_val * delta)
	

func _process(delta: float) -> void:
	camera_tilt(delta)
