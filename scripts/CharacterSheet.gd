extends Control

# Character Sheet - Detailed view of character information
# Shows all stats, skills, equipment, and status

# Preload dependencies
const Character = preload("res://data/Character.gd")

# UI References
@onready var character_name_label = $ScrollContainer/VBoxContainer/Header/CharacterName
@onready var character_class_label = $ScrollContainer/VBoxContainer/Header/CharacterClass
@onready var character_race_gender_label = $ScrollContainer/VBoxContainer/Header/RaceGender

# Stats panels
@onready var primary_stats_container = $ScrollContainer/VBoxContainer/StatsSection/PrimaryStats/StatsContainer
@onready var secondary_stats_container = $ScrollContainer/VBoxContainer/StatsSection/SecondaryStats/StatsContainer

# Skills panel
@onready var skills_container = $ScrollContainer/VBoxContainer/SkillsSection/SkillsContainer

# Equipment panel
@onready var equipment_container = $ScrollContainer/VBoxContainer/EquipmentSection/EquipmentContainer

# Health/Mana bars
@onready var health_bar = $ScrollContainer/VBoxContainer/VitalsSection/HealthBar
@onready var mana_bar = $ScrollContainer/VBoxContainer/VitalsSection/ManaBar
@onready var health_label = $ScrollContainer/VBoxContainer/VitalsSection/HealthLabel
@onready var mana_label = $ScrollContainer/VBoxContainer/VitalsSection/ManaLabel

# Buttons
@onready var back_button = $ScrollContainer/VBoxContainer/ButtonSection/BackButton

# Character data
var current_character: Character

func _ready():
	# Get character from game state
	current_character = GameState.get_current_character()
	
	if not current_character:
		print("No character found in game state")
		_return_to_tavern()
		return
	
	# Setup UI
	_setup_character_sheet()
	
	# Connect signals
	back_button.pressed.connect(_return_to_tavern)

func _setup_character_sheet():
	"""Setup the complete character sheet display"""
	_setup_header()
	_setup_vitals()
	_setup_primary_stats()
	_setup_secondary_stats()
	_setup_skills()
	_setup_equipment()

func _setup_header():
	"""Setup character header information"""
	character_name_label.text = current_character.name
	character_class_label.text = "Class: " + current_character.character_class
	character_race_gender_label.text = current_character.race + " • " + current_character.gender

func _setup_vitals():
	"""Setup health and mana bars"""
	# Health
	health_bar.max_value = current_character.max_health
	health_bar.value = current_character.health
	health_label.text = "Health: " + str(current_character.health) + "/" + str(current_character.max_health)
	
	# Mana
	mana_bar.max_value = current_character.max_mana
	mana_bar.value = current_character.mana
	mana_label.text = "Mana: " + str(current_character.mana) + "/" + str(current_character.max_mana)

func _setup_primary_stats():
	"""Setup primary stats display"""
	# Clear existing
	for child in primary_stats_container.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	# Create stat displays
	for stat_name in current_character.primary_stats:
		var stat_container = HBoxContainer.new()
		
		var stat_label = Label.new()
		stat_label.text = stat_name + ":"
		stat_label.custom_minimum_size.x = 120
		stat_container.add_child(stat_label)
		
		var value_label = Label.new()
		value_label.text = str(current_character.primary_stats[stat_name])
		value_label.add_theme_font_size_override("font_size", 16)
		stat_container.add_child(value_label)
		
		primary_stats_container.add_child(stat_container)

func _setup_secondary_stats():
	"""Setup secondary stats display"""
	# Clear existing
	for child in secondary_stats_container.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	# Important secondary stats to display
	var important_stats = [
		"Speed", "Carry Capacity", "Dodge", "Accuracy", "Critical Chance",
		"Armor Rating", "Magic Resistance", "Perception", "Stealth",
		"HP Regeneration", "MP Regeneration", "Spell Power", "Healing Power",
		"Movement Range", "Morale", "Stamina"
	]
	
	for stat_name in important_stats:
		if current_character.secondary_stats.has(stat_name):
			var stat_container = HBoxContainer.new()
			
			var stat_label = Label.new()
			stat_label.text = stat_name + ":"
			stat_label.custom_minimum_size.x = 150
			stat_container.add_child(stat_label)
			
			var value_label = Label.new()
			var value = current_character.secondary_stats[stat_name]
			# Format floating point values nicely
			if value is float:
				value_label.text = "%.1f" % value
			else:
				value_label.text = str(value)
			stat_container.add_child(value_label)
			
			secondary_stats_container.add_child(stat_container)

func _setup_skills():
	"""Setup skills display organized by category"""
	# Clear existing
	for child in skills_container.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	# Get skill categories
	var skill_categories = {
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
	
	for category_name in skill_categories:
		# Category header
		var category_label = Label.new()
		category_label.text = category_name
		category_label.add_theme_font_size_override("font_size", 16)
		category_label.add_theme_color_override("font_color", Color.YELLOW)
		skills_container.add_child(category_label)
		
		# Skills in category
		var category_skills = skill_categories[category_name]
		for skill_name in category_skills:
			var skill_value = current_character.skills.get(skill_name, 0)
			if skill_value > 0:  # Only show skills with points
				var skill_container = HBoxContainer.new()
				
				var skill_label = Label.new()
				skill_label.text = "  " + skill_name + ":"
				skill_label.custom_minimum_size.x = 160
				skill_container.add_child(skill_label)
				
				var value_label = Label.new()
				value_label.text = str(skill_value)
				skill_container.add_child(value_label)
				
				skills_container.add_child(skill_container)
		
		# Add spacing between categories
		var spacer = Label.new()
		spacer.text = ""
		skills_container.add_child(spacer)

func _setup_equipment():
	"""Setup equipment display"""
	# Clear existing
	for child in equipment_container.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	# For now, show basic equipment info
	var gold_container = HBoxContainer.new()
	var gold_label = Label.new()
	gold_label.text = "Gold:"
	gold_label.custom_minimum_size.x = 120
	gold_container.add_child(gold_label)
	
	var gold_value = Label.new()
	gold_value.text = str(current_character.gold)
	gold_value.add_theme_font_size_override("font_size", 16)
	gold_value.add_theme_color_override("font_color", Color.YELLOW)
	gold_container.add_child(gold_value)
	
	equipment_container.add_child(gold_container)
	
	# Show inventory if any
	if current_character.inventory.size() > 0:
		var inventory_label = Label.new()
		inventory_label.text = "Inventory:"
		inventory_label.add_theme_font_size_override("font_size", 14)
		equipment_container.add_child(inventory_label)
		
		for item in current_character.inventory:
			var item_label = Label.new()
			item_label.text = "  • " + str(item)
			equipment_container.add_child(item_label)
	else:
		var no_items_label = Label.new()
		no_items_label.text = "No equipment yet"
		no_items_label.add_theme_color_override("font_color", Color.GRAY)
		equipment_container.add_child(no_items_label)

func _return_to_tavern():
	"""Return to the tavern scene"""
	get_tree().change_scene_to_file("res://scenes/Tavern.tscn")