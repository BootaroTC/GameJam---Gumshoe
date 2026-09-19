extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func change_character(character_name : Character.Name, is_talking : bool = true):
	var sprite_frames = Character.CHARACTER_DETAILS[character_name]["sprite_frames"]
	if sprite_frames:
		animated_sprite_2d.sprite_frames = sprite_frames
		if is_talking:
			animated_sprite_2d.play("Speaking")
		else:
			animated_sprite_2d.play("Idle")
	else:
		animated_sprite_2d.play("Idle")

func play_idle_animation():
	animated_sprite_2d.play("Idle")
