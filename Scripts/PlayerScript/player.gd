class_name Player extends CharacterBody3D

@export var SPEED = 20.0
@export var mouse_sens:float = 0.01

var max_heatlh = 3
var health = 0


var can_slide = true
var is_sliding = false
var slide_dir = Vector3.ZERO
var sliding_val = 40.0
var max_sliding_amount = 35.0

var max_ammo = 6
var ammo = 0
var is_shooting  = false
var reloading = false

@onready var neck: Node3D = $Neck
@onready var camera_3d: Camera3D = $Neck/Camera3D
@onready var ray_cast_3d: RayCast3D = $Neck/RayCast3D
@onready var animated_sprite_3d: AnimatedSprite3D = $Neck/Camera3D/AnimatedSprite3D
@onready var crosshair: AnimatedSprite3D = $Neck/Camera3D/Crosshair
@onready var animation_player: AnimationPlayer = $Neck/Camera3D/Crosshair/AnimationPlayer
@onready var slide_anim: AnimationPlayer = $Neck/SlideAnim
@onready var shoot_animation: AnimationPlayer = $Neck/Camera3D/Crosshair/ShootAnimation

func _ready() -> void:
	health = max_heatlh
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	ammo = max_ammo

func health_check():
	if health > max_heatlh:
		health = max_heatlh
	
	if health <= 0:
		queue_free()
	

func shooting():
	if ammo > 0:
		if ray_cast_3d.is_colliding() && Input.is_action_just_pressed("shoot"):
			ray_cast_3d.get_collider().queue_free() 
			
		if Input.is_action_just_pressed("shoot") and !is_shooting:
			ammo -= 1
			is_shooting = true
			animated_sprite_3d.play("Shoot")
			if ammo == 0:
				shoot_animation.play("ShootLastBullet")
			else:
				shoot_animation.play("Shoot")
				
			await get_tree().create_timer(0.25).timeout
			is_shooting = false
		else: 
			if animated_sprite_3d.is_playing() != true:
				animated_sprite_3d.play("Idle")
	
	if ammo <= 5:
		_reloading()

func _reloading():
	if ((ammo <= 0) or (ammo <= 5 and Input.is_action_just_pressed("reload"))) and !reloading and !is_shooting:
		reloading = true
		animated_sprite_3d.play("Idle")
		animation_player.play("ReloadSpin")
		shoot_animation.play("Reload")
		await get_tree().create_timer(2.5).timeout
		ammo = max_ammo
		reloading = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_motion:Vector2 = event.relative
		rotate_y(-(mouse_motion.x * mouse_sens))
		neck.rotate_x(-(mouse_motion.y * mouse_sens))
		neck.rotation.x = deg_to_rad(clamp(rad_to_deg(neck.rotation.x), -90, 50))

func slide(delta):
	if Input.is_action_just_pressed("slide") and !is_sliding:
		is_sliding = true
		slide_anim.play("Slide")
	
	if is_sliding:
		if SPEED < max_sliding_amount:
			SPEED += delta * sliding_val
		if SPEED >= max_sliding_amount:
			is_sliding = false
		
	
	if SPEED > 20.0 and !is_sliding:
		SPEED -= delta * sliding_val
		slide_anim.play("Reset_Slide")
	
		
	if SPEED <= 20.0:
		SPEED = 20.0
		is_sliding = false

func movement(delta):
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
	
	slide(delta)
	
	move_and_slide()

func _physics_process(delta: float) -> void:
	health_check()
	shooting()
	movement(delta)
	print(health)
