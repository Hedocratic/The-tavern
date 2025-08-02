class_name SkillManager
extends RefCounted

# Manages skill allocation and validation for character creation
# Organizes skills by category and handles point allocation

signal skill_points_changed(available_points: int)
signal skill_values_changed(skills: Dictionary)

var available_skill_points: int = 10
var character: Character

# Organized skill categories
var skill_categories: Dictionary = {
	"Combat Skills": [
		"Slashing Weapons", "Blunt Weapons", "Piercing Weapons", 
		"Archery", "Throwing Weapons", "Shields", "Dual Wielding", 
		"Unarmed Combat", "Heavy Armor", "Light Armor", "Dodge"
	],
	"Magic Skills": [
		"Evocation", "Restoration", "Illusion", "Enchantment", 
		"Necromancy", "Arcane Knowledge", "Alchemy", "Ritual Magic", "Summoning"
	],
	"Stealth & Subterfuge": [
		"Stealth", "Pickpocketing", "Lockpicking", "Trap Setting", 
		"Trap Disarming", "Poison Crafting", "Backstab"
	],
	"Social Skills": [
		"Persuasion", "Intimidation", "Seduction", "Deception", 
		"Performance", "Bartering"
	],
	"Survival & Utility": [
		"Survival", "Tracking", "Animal Handling", "First Aid", 
		"Swimming", "Climbing", "Fishing", "Cooking", "Navigation", 
		"Memory", "Crafting", "Blacksmithing", "Brewing", "Herbalism"
	],
	"Special Skills": [
		"Leadership", "Morale Boosting", "Inspiration", "Disguise", 
		"Lore", "Investigation"
	]
}

func _init(initial_character: Character = null):
	if initial_character:
		character = initial_character
	else:
		character = Character.new()

func set_character(new_character: Character):
	"""Set the character being managed"""
	character = new_character
	skill_values_changed.emit(character.skills)

func get_skill_value(skill_name: String) -> int:
	"""Get current value of a specific skill"""
	return character.skills.get(skill_name, 0)

func can_change_skill(skill_name: String, new_value: int) -> bool:
	"""Check if a skill change is valid given available points"""
	var current_value = get_skill_value(skill_name)
	var difference = new_value - current_value
	return available_skill_points >= difference

func change_skill(skill_name: String, new_value: int) -> bool:
	"""Attempt to change a skill value, returns true if successful"""
	if not can_change_skill(skill_name, new_value):
		return false
	
	var current_value = get_skill_value(skill_name)
	var difference = new_value - current_value
	
	character.skills[skill_name] = new_value
	available_skill_points -= difference
	character._calculate_secondary_stats()
	
	skill_points_changed.emit(available_skill_points)
	skill_values_changed.emit(character.skills)
	
	return true

func reset_skills():
	"""Reset all skills to 0 and restore available points"""
	available_skill_points = 10
	for category in skill_categories:
		for skill in skill_categories[category]:
			character.skills[skill] = 0
	
	character._calculate_secondary_stats()
	skill_points_changed.emit(available_skill_points)
	skill_values_changed.emit(character.skills)

func apply_class_bonuses(character_class: CharacterClass):
	"""Apply class-specific skill bonuses"""
	# Reset to base first
	available_skill_points = 10
	
	# Apply class starting skills
	for skill in character_class.starting_skills:
		character.skills[skill] = character_class.starting_skills[skill]
	
	character._calculate_secondary_stats()
	skill_points_changed.emit(available_skill_points)
	skill_values_changed.emit(character.skills)

func get_available_points() -> int:
	"""Get the number of available skill points"""
	return available_skill_points

func get_all_skills() -> Dictionary:
	"""Get all current skills"""
	return character.skills.duplicate()

func get_skill_categories() -> Dictionary:
	"""Get organized skill categories"""
	return skill_categories

func validate_skill_allocation() -> bool:
	"""Validate that skill allocation is complete and valid"""
	# Check available points are non-negative
	if available_skill_points < 0:
		return false
	
	# Check all skills are within valid range
	if not character or not character.skills:
		return false
		
	for skill_name in character.skills:
		var skill_value = character.skills[skill_name]
		if skill_value < 0 or skill_value > 10:
			return false
	
	return true

func get_skill_allocation_info() -> Dictionary:
	"""Get detailed information about skill allocation"""
	return {
		"available_points": available_skill_points,
		"total_allocated": _calculate_total_allocated_skills(),
		"is_valid": validate_skill_allocation()
	}

func _calculate_total_allocated_skills() -> int:
	"""Calculate total skill points allocated"""
	if not character or not character.skills:
		return 0
		
	var total = 0
	for skill_name in character.skills:
		total += character.skills[skill_name]
	return total

func get_skills_in_category(category_name: String) -> Array:
	"""Get all skills in a specific category"""
	return skill_categories.get(category_name, [])