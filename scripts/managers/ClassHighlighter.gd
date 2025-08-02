class_name ClassHighlighter
extends RefCounted

# Manages visual highlighting of stats based on character class selection
# Data-driven approach to replace hard-coded switch statements

var class_stat_preferences: Dictionary = {
	"Warrior": {
		"primary": ["Strength", "Fortitude"],
		"color": Color.LIGHT_GREEN
	},
	"Wizard": {
		"primary": ["Intelligence", "Arcane"],
		"color": Color.LIGHT_BLUE
	},
	"Thief": {
		"primary": ["Agility"],
		"color": Color.YELLOW
	},
	"Paladin": {
		"primary": ["Strength", "Fortitude", "Charisma"],
		"color": Color.PINK
	},
	"Barbarian": {
		"primary": ["Strength", "Fortitude"],
		"color": Color.RED
	},
	"Assassin": {
		"primary": ["Agility", "Strength"],
		"color": Color.DARK_RED
	},
	"Cleric": {
		"primary": ["Charisma", "Arcane"],
		"color": Color.GOLD
	},
	"Druid": {
		"primary": ["Intelligence", "Arcane", "Agility"],
		"color": Color.GREEN
	},
	"Necromancer": {
		"primary": ["Intelligence", "Arcane"],
		"color": Color.PURPLE
	},
	"Warlock": {
		"primary": ["Arcane", "Charisma"],
		"color": Color.VIOLET
	},
	"Monk": {
		"primary": ["Agility", "Fortitude", "Strength"],
		"color": Color.ORANGE
	},
}


func get_highlighted_stats(class_name: String) -> Array[String]:
	"""Get the stats that should be highlighted for a given class"""
	var class_data = class_stat_preferences.get(class_name, {})
	return class_data.get("primary", [])

func get_highlight_color(class_name: String) -> Color:
	"""Get the highlight color for a given class"""
	var class_data = class_stat_preferences.get(class_name, {})
	return class_data.get("color", Color.WHITE)

func should_highlight_stat(class_name: String, stat_name: String) -> bool:
	"""Check if a specific stat should be highlighted for a class"""
	var highlighted_stats = get_highlighted_stats(class_name)
	return stat_name in highlighted_stats

func apply_highlighting(class_name: String, stat_spinboxes: Dictionary):
	"""Apply highlighting to stat spinboxes based on class"""
	var highlighted_stats = get_highlighted_stats(class_name)
	var highlight_color = get_highlight_color(class_name)
	
	# Reset all to normal color first
	for stat_name in stat_spinboxes:
		var spinbox = stat_spinboxes[stat_name]
		if spinbox:
			spinbox.modulate = Color.WHITE
	
	# Apply highlighting to preferred stats
	for stat_name in highlighted_stats:
		var spinbox = stat_spinboxes.get(stat_name)
		if spinbox:
			spinbox.modulate = highlight_color

func get_class_description(class_name: String) -> String:
	"""Get a description of what stats are emphasized for a class"""
	var highlighted_stats = get_highlighted_stats(class_name)
	if highlighted_stats.is_empty():
		return "Selected class: " + class_name
	
	var stats_text = ", ".join(highlighted_stats)
	return "Selected " + class_name + " - emphasizing " + stats_text

func add_class_preference(class_name: String, primary_stats: Array[String], color: Color):
	"""Add or update class stat preferences (for extensibility)"""
	class_stat_preferences[class_name] = {
		"primary": primary_stats,
		"color": color
	}

func get_all_classes() -> Array[String]:
	"""Get all available character classes"""
	return class_stat_preferences.keys()
