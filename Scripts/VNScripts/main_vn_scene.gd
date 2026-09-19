extends Node2D

@onready var dialog_ui: Control = $CanvasLayer2/DialogUI
@onready var character_sprite: Node2D = $CanvasLayer2/Control/CharacterSprite


# to tell script what point in the code its at
var dialog_index : int = 0

const dialog_lines : Array[String] = [
	"Goole: Yo, I think we lowk gotta kill this guy.",
	"BadGuy: I'm gonna friiigggin ERASE you noob!",
	"Goole: Heh... Guess I've gotta use it at last... ban.....kai...",
	"BadGuy: *locks in* [shake]SEGUNDA ETAPA[/shake]!!"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#connect signal
	dialog_ui.text_animation_done.connect(_on_text_animation_done)
	#process first line of dialog
	dialog_index = 0
	process_current_line()

func _input(event):
	if event.is_action_pressed("next_line"):
		if dialog_ui.animate_text:
			dialog_ui.skip_text_animation()
		else:
			if dialog_index < len(dialog_lines) - 1: #checks if the index isnt more than amount of lines
				dialog_index += 1
				process_current_line()
			
func parse_line(line: String):
	var line_info = line.split(":")
	assert(len(line_info) >= 2) #idk I saw the guy do this but I think it just returns an error if the line length is less than 2 so just bug checking
	return {
		"speaker_name": line_info[0],
		"dialog_line": line_info[1]
	}

func process_current_line():
	var line = dialog_lines[dialog_index]
	var line_info = parse_line(line)
	var character_name = Character.get_enum_from_string(line_info["speaker_name"])
	dialog_ui.change_line(character_name, line_info["dialog_line"])
	character_sprite.change_character(character_name)

func _on_text_animation_done():
	character_sprite.play_idle_animation()
