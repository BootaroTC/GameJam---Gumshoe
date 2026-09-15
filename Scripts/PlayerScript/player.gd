extends CharacterBody3D


@export var SPEED = 5.0
@export var mouse_sens:float = 0.01
@export var camera_tilt_val:float = 4
@export var max_tilt = 0.08
@export var target_tilt = 0.0


@onready var neck: Node3D = $Neck
@onready var camera_3d: Camera3D = $Neck/Camera3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func camera_tilt(delta):
	var input_axis = Input.get_axis("left", "right")
	target_tilt = -input_axis * max_tilt
	
	camera_3d.rotation.z = lerp(camera_3d.rotation.z, target_tilt, camera_tilt_val * delta)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_motion:Vector2 = event.relative
		rotate_y(-(mouse_motion.x * mouse_sens))
		neck.rotate_x(-(mouse_motion.y * mouse_sens))
		neck.rotation.x = deg_to_rad(clamp(rad_to_deg(neck.rotation.x), -90, 50))

func movement(delta):
	camera_tilt(delta)
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _physics_process(delta: float) -> void:
	movement(delta)
