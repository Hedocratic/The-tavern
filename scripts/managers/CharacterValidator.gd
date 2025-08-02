class_name CharacterValidator
extends RefCounted

# Handles validation for character creation
# Provides user-friendly error messages and validation rules

enum ValidationResult {
	VALID,
	INVALID_NAME,
	INVALID_STATS,
	INVALID_SKILLS,
	MISSING_SELECTION
}

func validate_character(character: Character, stat_manager: StatManager, skill_manager: SkillManager) -> Dictionary:
	"""
	Validate a character for creation
	Returns: { "valid": bool, "result": ValidationResult, "message": String }
	"""
	
	# Check name
	if character.name.is_empty() or character.name.strip_edges().is_empty():
		return {
			"valid": false,
			"result": ValidationResult.INVALID_NAME,
			"message": "Please enter a character name"
		}
	
	# Check name length
	if character.name.length() > 30:
		return {
			"valid": false,
			"result": ValidationResult.INVALID_NAME,
			"message": "Character name must be 30 characters or less"
		}
	
	# Check for invalid characters in name
	if not _is_valid_name(character.name):
		return {
			"valid": false,
			"result": ValidationResult.INVALID_NAME,
			"message": "Character name contains invalid characters"
		}
	
	# Check class selection
	if character.character_class.is_empty():
		return {
			"valid": false,
			"result": ValidationResult.MISSING_SELECTION,
			"message": "Please select a character class"
		}
	
	# Check stat allocation
	if not stat_manager.validate_stat_allocation():
		return {
			"valid": false,
			"result": ValidationResult.INVALID_STATS,
			"message": "Invalid stat allocation"
		}
	
	# Check skill allocation
	if not skill_manager.validate_skill_allocation():
		return {
			"valid": false,
			"result": ValidationResult.INVALID_SKILLS,
			"message": "Invalid skill allocation"
		}
	
	# All validation passed
	return {
		"valid": true,
		"result": ValidationResult.VALID,
		"message": "Character is ready for creation"
	}

func _is_valid_name(name: String) -> bool:
	"""Check if character name contains only valid characters"""
	# Allow letters, numbers, spaces, hyphens, apostrophes
	var regex = RegEx.new()
	regex.compile("^[a-zA-Z0-9 '-]+$")
	return regex.search(name) != null

func validate_name_realtime(name: String) -> Dictionary:
	"""Provide real-time name validation feedback"""
	if name.is_empty():
		return {
			"valid": false,
			"message": "Name cannot be empty"
		}
	
	if name.length() > 30:
		return {
			"valid": false,
			"message": "Name too long (" + str(name.length()) + "/30)"
		}
	
	if not _is_valid_name(name):
		return {
			"valid": false,
			"message": "Invalid characters in name"
		}
	
	return {
		"valid": true,
		"message": "Valid name"
	}

func get_stat_allocation_summary(stat_manager: StatManager) -> String:
	"""Get a summary of current stat allocation"""
	var available = stat_manager.get_available_points()
	if available > 0:
		return str(available) + " stat points remaining"
	elif available == 0:
		return "All stat points allocated"
	else:
		return "Over-allocated by " + str(abs(available)) + " points"

func get_skill_allocation_summary(skill_manager: SkillManager) -> String:
	"""Get a summary of current skill allocation"""
	var available = skill_manager.get_available_points()
	if available > 0:
		return str(available) + " skill points remaining"
	elif available == 0:
		return "All skill points allocated"
	else:
		return "Over-allocated by " + str(abs(available)) + " points"

func suggest_improvements(character: Character) -> Array[String]:
	"""Suggest improvements to character build"""
	var suggestions: Array[String] = []
	
	# Check for unallocated points
	# Note: This would need access to managers, or we could pass the points directly
	
	# Check for imbalanced stats
	var stats = character.primary_stats
	var total_stats = 0
	var min_stat = 999
	var max_stat = 0
	
	for stat_value in stats.values():
		total_stats += stat_value
		min_stat = min(min_stat, stat_value)
		max_stat = max(max_stat, stat_value)
	
	if max_stat - min_stat > 10:
		suggestions.append("Consider balancing your stats - you have very high and very low stats")
	
	if min_stat < 5:
		suggestions.append("Very low stats can severely limit your character's abilities")
	
	return suggestions