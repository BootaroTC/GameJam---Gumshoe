extends CharacterBody3D

@onready var player = get_tree().get_first_node_in_group("Player")

var target = null

func _ready() -> void:
	target = player

func target_player():
	look_at(target.global_transform.origin,Vector3.UP)


func _physics_process(_delta: float) -> void:
	target_player()
