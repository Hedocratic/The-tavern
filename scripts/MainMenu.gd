extends Control

# Main Menu Script
# Handles the main entry point of The Tavern game

@onready var start_button = $VBoxContainer/StartButton
@onready var options_button = $VBoxContainer/OptionsButton
@onready var quit_button = $VBoxContainer/QuitButton

func _ready():
	# Connect button signals
	start_button.pressed.connect(_on_start_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	# Focus the start button by default
	start_button.grab_focus()

func _on_start_pressed():
	# Transition to character creation scene
	print("Starting new game...")
	get_tree().change_scene_to_file("res://scenes/CharacterCreation.tscn")

func _on_options_pressed():
	# TODO: Implement options menu
	print("Options menu not yet implemented")

func _on_quit_pressed():
	# Quit the game
	print("Quitting game...")
	get_tree().quit()