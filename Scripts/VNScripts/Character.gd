class_name Character
extends Node

enum Name  {
	BADGUY,
	GOOLE
}

const CHARACTER_DETAILS : Dictionary = {
	Name.BADGUY: {
		"name": "Bad Guy",
		"morals": "Evil.",
		"sprite_frames": preload("res://Sprites/VNAssets/Characters/BadGuyTest/BadGuyAnimations.tres")
	},
	Name.GOOLE: {
		"name": "Goole",
		"morals": "Very good",
		"sprite_frames": preload("res://Sprites/VNAssets/Characters/TestGoodGuy/GooleAnimations.tres")
	}
}

static func get_enum_from_string(string_value: String) -> int:
	var upper_string = string_value.to_upper()
	if Name.has(upper_string):
		return Name[upper_string]
	else:
		push_error("Invalid Character Name" + string_value)
		return -1
