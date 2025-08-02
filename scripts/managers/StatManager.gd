class_name StatManager
extends RefCounted

# Manages stat allocation and validation for character creation
# Separates stat-related logic from UI concerns

signal stat_points_changed(available_points: int)
signal stat_values_changed(stats: Dictionary)

var available_stat_points: int = 20
var character: Character

func _init(initial_character: Character = null):
	if initial_character:
		character = initial_character
	else:
		character = Character.new()

func set_character(new_character: Character):
	"""Set the character being managed"""
	character = new_character
	stat_values_changed.emit(character.primary_stats)

func get_stat_value(stat_name: String) -> int:
	"""Get current value of a specific stat"""
	return character.primary_stats.get(stat_name, 10)

func can_change_stat(stat_name: String, new_value: int) -> bool:
	"""Check if a stat change is valid given available points"""
	var current_value = get_stat_value(stat_name)
	var difference = new_value - current_value
	return available_stat_points >= difference

func change_stat(stat_name: String, new_value: int) -> bool:
	"""Attempt to change a stat value, returns true if successful"""
	if not can_change_stat(stat_name, new_value):
		return false
	
	var current_value = get_stat_value(stat_name)
	var difference = new_value - current_value
	
	character.primary_stats[stat_name] = new_value
	available_stat_points -= difference
	character._calculate_secondary_stats()
	
	stat_points_changed.emit(available_stat_points)
	stat_values_changed.emit(character.primary_stats)
	
	return true

func reset_stats():
	"""Reset all stats to base values and restore available points"""
	available_stat_points = 20
	for stat in character.primary_stats:
		character.primary_stats[stat] = 10
	
	character._calculate_secondary_stats()
	stat_points_changed.emit(available_stat_points)
	stat_values_changed.emit(character.primary_stats)

func apply_class_bonuses(character_class: CharacterClass):
	"""Apply class-specific stat bonuses"""
	# Reset to base first
	available_stat_points = 20
	
	# Apply class starting stats
	for stat in character_class.starting_stats:
		character.primary_stats[stat] = character_class.starting_stats[stat]
	
	character._calculate_secondary_stats()
	stat_points_changed.emit(available_stat_points)
	stat_values_changed.emit(character.primary_stats)

func get_available_points() -> int:
	"""Get the number of available stat points"""
	return available_stat_points

func get_all_stats() -> Dictionary:
	"""Get all current primary stats"""
	return character.primary_stats.duplicate()

func validate_stat_allocation() -> bool:
	"""Validate that stat allocation is complete and valid"""
	# Could add additional validation rules here
	return available_stat_points >= 0