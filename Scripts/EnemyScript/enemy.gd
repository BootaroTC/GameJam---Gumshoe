extends CharacterBody3D

@onready var player = get_tree().get_first_node_in_group("Player")


@onready var ray_shoot: RayCast3D = $Shoot

var target = null

var can_shoot = true

func _ready() -> void:
	target = player

func target_player():
	look_at(target.global_transform.origin,Vector3.UP)

func shoot():
	if can_shoot:
		can_shoot = false
		if ray_shoot.is_colliding():
			if ray_shoot.get_collider() == target:
				if randf() < 0.15:
					target.queue_free()

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
