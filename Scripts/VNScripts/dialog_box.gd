extends Control

signal text_animation_done

@onready var dialog_line: RichTextLabel = $DialogBox/DialogLine
@onready var speaker_name: Label = $PanelContainer/SpeakerName
@onready var text_blip_sound: AudioStreamPlayer2D = %TextBlipSound
@onready var text_blip_timer: Timer = %TextBlipTimer


const ANIMATION_SPEED : int = 30
const NO_SOUND_CHARS : Array = [".", "!", "?"]

var animate_text : bool = false
var current_visible_caracters : int = 0
var current_character_details : Dictionary 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_blip_timer.timeout.connect(_on_text_blip_timeout)
	
func _process(delta: float) -> void:
	if animate_text:
		if dialog_line.visible_ratio < 1:
			dialog_line.visible_ratio += (1.0/dialog_line.text.length()) * (ANIMATION_SPEED * delta)
			if dialog_line.visible_characters > current_visible_caracters:
				current_visible_caracters = dialog_line.visible_characters

		else:
			animate_text = false
			text_animation_done.emit()

func change_line(character_name: Character.Name, line : String):
	current_character_details = Character.CHARACTER_DETAILS[character_name]
	speaker_name.text = Character.CHARACTER_DETAILS[character_name]["name"]
	current_visible_caracters = 0
	dialog_line.visible_characters = 0
	dialog_line.text = line
	animate_text = true
	text_blip_timer.start()

func skip_text_animation():
	dialog_line.visible_ratio = 1

func _on_text_blip_timeout():
	text_blip_sound.play_sound(current_character_details)
