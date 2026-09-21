extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func change_character(character_name : Character.Name, is_talking : bool, expression : String):
	var sprite_frames = Character.CHARACTER_DETAILS[character_name]["sprite_frames"]
	var stance  = "talking" if is_talking else "idle"
	var animation_name = expression + "-" + stance if expression else stance
	
	# if the character has sprite_frames update animated sprites and play animation
	if sprite_frames:
		animated_sprite_2d.sprite_frames = sprite_frames
		# check if associated expression exists if not play default stance
		if animated_sprite_2d.sprite_frames.has_animation(animation_name):
			animated_sprite_2d.play(animation_name)
		else:
			animated_sprite_2d.play(stance)
	else:
		# Swtich to idle of character currently displayed
		play_idle_animation()

func play_idle_animation():
	var last_animation = animated_sprite_2d.animation
	if last_animation and not last_animation.ends_with("-idle"):
		# if a custom expression is displayed try find idle animation
		# if it exists play it, otherwise play the normal idle
		var idle_expression = last_animation.replace("talking", "idle")
		if animated_sprite_2d.sprite_frames.has_animation(idle_expression):
			animated_sprite_2d.play(idle_expression)
		else:
			animated_sprite_2d.play("idle")
