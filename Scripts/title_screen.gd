extends Node2D

@onready var new_game_button: Button = %NewGameButton
@onready var vn_test_button: Button = %VNTestButton
@onready var quit_button: Button = %QuitButton

var scene_to_change : String = ""

func _ready() -> void:
	new_game_button.pressed.connect(_on_new_game_button)
	quit_button.pressed.connect(_on_quit_button)
	vn_test_button.pressed.connect(_on_vn_test_button)
	SceneManager.transition_out_completed.connect(_on_transition_out_completed)
	
func _on_new_game_button():
	SceneManager.transition_out()
	scene_to_change = "res://Scene/TestScene/node_3d.tscn"

func _on_quit_button():
	get_tree().quit()

func _on_vn_test_button():
	SceneManager.transition_out()
	scene_to_change = "res://Scene/VNScenes/Test.tscn"

func _on_transition_out_completed():
	SceneManager.change_scene(scene_to_change)
	SceneManager.transition_in()
