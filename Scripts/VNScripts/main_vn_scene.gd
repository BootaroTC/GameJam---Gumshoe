extends Node2D

@onready var dialog_ui: Control = $CanvasLayer2/DialogUI
@onready var character_sprite: Node2D = $CanvasLayer2/Control/CharacterSprite
@onready var background: TextureRect = %Background


# to tell script what point in the code its at
var transition_effect: String = "fade"
var dialog_file: String = "res://Sprites/VNAssets/Story/first_scene.json"
var dialog_index : int = 0
var dialog_lines : Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#load dialog
	dialog_lines = load_dialog(dialog_file)
	#connect signal
	dialog_ui.text_animation_done.connect(_on_text_animation_done)
	dialog_ui.choice_selected.connect(_on_choice_selected)
	SceneManager.transition_out_completed.connect(_on_transition_out_completed)
	SceneManager.transition_in_completed.connect(_on_transition_in_completed)
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
	if line.has("next_scene"):
		var next_scene = line["next_scene"]
		dialog_file = "res://Sprites/VNAssets/Story/" + next_scene + ".JSON" if !next_scene.is_empty() else ""
		transition_effect = line.get("transition", "fade")
		SceneManager.transition_out(transition_effect)
		return
		
	# Check if has Location
	if line.has("location"):
		var background_file = "res://Sprites/VNAssets/Backgrounds/" + line["location"] + ".png"
		background.texture = load(background_file)
		# var music_file = 
		dialog_index += 1
		process_current_line()
		return
		
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
		
	# update character expression sprite, default to speaker commeand if no show_character
	if line.has("show_character"):
		var character_name = Character.get_enum_from_string(line["show_character"])
		character_sprite.change_character(character_name, false, line.get("expression", ""))
	elif line.has("speaker"):
		var character_name = Character.get_enum_from_string(line["speaker"])
		character_sprite.change_character(character_name, true, line.get("expression", ""))
	# Check Choices
	if line.has("choices"):
		# Display Choices
		dialog_ui.display_choices(line["choices"])
	else:
		# Reading Dialog
		var character_name = Character.get_enum_from_string(line["speaker"])
		dialog_ui.change_line(character_name, line["text"])

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

func _on_transition_out_completed():
	# load new dialog and scene
	if !dialog_file.is_empty():
		dialog_lines = load_dialog(dialog_file)
		dialog_index = 0
		var first_line = dialog_lines[dialog_index]
		if first_line.has("location"):
			background.texture = load("res://Sprites/VNAssets/Backgrounds/" + first_line["location"] + ".png")
			#new music switch
			dialog_index += 1
		SceneManager.transition_in(transition_effect)
		process_current_line()
	else:
		print("end")

func _on_transition_in_completed():
	# process dialog
	pass
