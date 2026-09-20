extends Node2D

@onready var dialog_ui: Control = $CanvasLayer2/DialogUI
@onready var character_sprite: Node2D = $CanvasLayer2/Control/CharacterSprite


# to tell script what point in the code its at
var dialog_index : int = 0

var dialog_lines : Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#load dialog
	dialog_lines = load_dialog("res://Sprites/VNAssets/Story/Story.json")
	#connect signal
	dialog_ui.text_animation_done.connect(_on_text_animation_done)
	dialog_ui.choice_selected.connect(_on_choice_selected)
	#dialog_ui.sentence_pause.connect(_on_sentence_pause)
	#process first line of dialog
	dialog_index = 0
	process_current_line()

func _input(event):
	var line = dialog_lines[dialog_index]
	var has_choices = line.has("choices")
	if event.is_action_pressed("next_line") and not has_choices:
		if dialog_ui.animate_text:
			dialog_ui.skip_text_animation()
		else:
			if dialog_index < len(dialog_lines) - 1: #checks if the index isnt more than amount of lines
				dialog_index += 1
				process_current_line()
			

func process_current_line():
	var line = dialog_lines[dialog_index]
	# Check if this is goto command
	if line.has("goto"):
		dialog_index = get_anchor_position(line["goto"])
		process_current_line()
		return
	
	# Check if this is just an anchor declaration
	if line.has("anchor"):
		dialog_index += 1
		process_current_line()
		return
		
	# Check Choices
	if line.has("choices"):
		# Display Choices
		dialog_ui.display_choices(line["choices"])
	else:
		# Reading Dialog
		var character_name = Character.get_enum_from_string(line["speaker"])
		dialog_ui.change_line(character_name, line["text"])
		character_sprite.change_character(character_name)

func get_anchor_position(anchor: String):
	# Find the anchor with matching name
	for i in range(dialog_lines.size()):
		if dialog_lines[i].has("anchor") and dialog_lines[i]["anchor"] == anchor:
			return i
			
	# Anchor wasnt found here
	print("Error: could not find anchor: " + anchor)
	return null

func load_dialog(file_path):
	# check if file exist
	if not FileAccess.file_exists(file_path):
		print("Error: File does not exist: " + file_path)
		return null
		
	# Open the file
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		print("Error: Failed to open file: " + file_path)
		return null
		
	# Read as text
	var content = file.get_as_text()
	
	# Parse Json
	var json_content = JSON.parse_string(content)
	
	# Check if Parsin was successful
	if json_content == null:
		print("Error: Failed to parse JSON from file: " + file_path)
		return null
	
	return json_content

func _on_text_animation_done():
	character_sprite.play_idle_animation()

func _on_choice_selected(anchor: String):
	dialog_index = get_anchor_position(anchor)
	process_current_line()
