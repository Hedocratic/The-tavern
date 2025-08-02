extends Control

# Main Menu script for The Tavern
# Handles navigation to different game screens

func _on_new_game_button_pressed():
	# Navigate to character creation screen
	print("Starting new game - going to character creation")
	get_tree().change_scene_to_file("res://scenes/CharacterCreation.tscn")

func _on_load_game_button_pressed():
	# TODO: Implement save game loading
	print("Load game pressed - not implemented yet")

func _on_options_button_pressed():
	# TODO: Implement options menu
	print("Options pressed - not implemented yet")

func _on_quit_button_pressed():
	# Quit the game
	print("Quitting game")
	get_tree().quit()