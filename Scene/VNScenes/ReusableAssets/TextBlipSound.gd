extends AudioStreamPlayer2D

const voice_sounds : Dictionary = {
	"Evil.": preload("res://Sprites/VNAssets/SFX/Voice/sfx-blipmale.wav"),
	"Very good": preload("res://Sprites/VNAssets/SFX/Voice/voice_sans.wav")
}

func play_sound(character_details: Dictionary):
	var character_morals =  character_details["morals"]
	stream = voice_sounds[character_morals]
	play()
