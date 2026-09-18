extends CharacterBody3D

@onready var player = get_tree().get_first_node_in_group("Player")

@onready var ray_shoot: RayCast3D = $Ray_Shoot
@onready var sprite_3d: AnimatedSprite3D = $Sprite3D



var target = null

var can_shoot = true

func _ready() -> void:
	target = player
	sprite_3d.play("Idle")

func _animation_handler():
	if can_shoot:
		sprite_3d.play("Idle")
	else: sprite_3d.play("Shoot")

func target_player():
	look_at(target.global_transform.origin,Vector3.UP)

func shoot():
	if can_shoot:
		can_shoot = false
		if ray_shoot.is_colliding():
			if ray_shoot.get_collider() == target:
				if randf() < 0.15:
					target.health -= 1
					player.healthbar.value = player.health

func _on_timer_timeout() -> void:
	can_shoot = true

func _in_range_of_player():
	var distance_to_player = global_position.distance_to(target.global_position)
	
	if distance_to_player <= 15:
		target_player()
	
	if distance_to_player <= 10:
		shoot()

func _physics_process(_delta: float) -> void:
	_in_range_of_player()
	_animation_handler()
