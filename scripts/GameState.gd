extends Node

# Global game state manager
# This autoload singleton manages data that needs to persist between scenes

# Preload the Character class
const Character = preload("res://data/Character.gd")

var current_character: Character = null
var party_members: Array[Character] = []
var game_data: Dictionary = {}

func set_current_character(character: Character):
	"""Set the current player character"""
	current_character = character
	if party_members.is_empty():
		party_members.append(character)
	print("GameState: Character set - ", character.name)

func get_current_character() -> Character:
	"""Get the current player character"""
	return current_character

func add_party_member(character: Character):
	"""Add a character to the party"""
	if not party_members.has(character):
		party_members.append(character)
		print("GameState: Party member added - ", character.name)

func remove_party_member(character: Character):
	"""Remove a character from the party"""
	if party_members.has(character):
		party_members.erase(character)
		print("GameState: Party member removed - ", character.name)

func get_party() -> Array[Character]:
	"""Get all party members"""
	return party_members

func save_game_data(key: String, value):
	"""Save arbitrary game data"""
	game_data[key] = value

func load_game_data(key: String, default_value = null):
	"""Load arbitrary game data"""
	return game_data.get(key, default_value)