extends Control

# Character Creation Screen
# This script handles the creation and customization of player characters

@export var character_classes: Array[CharacterClass] = []
var current_character: Character
var available_stat_points: int = 20
var available_skill_points: int = 10

# UI References
@onready var name_line_edit = $ScrollContainer/VBoxContainer/CharacterName/LineEdit
@onready var class_option_button = $ScrollContainer/VBoxContainer/ClassSelection/OptionButton
@onready var race_option_button = $ScrollContainer/VBoxContainer/RaceSelection/OptionButton
@onready var gender_option_button = $ScrollContainer/VBoxContainer/GenderSelection/OptionButton

# Stat spinboxes
@onready var strength_spinbox = $ScrollContainer/VBoxContainer/Stats/StrengthContainer/SpinBox
@onready var fortitude_spinbox = $ScrollContainer/VBoxContainer/Stats/FortitudeContainer/SpinBox
@onready var agility_spinbox = $ScrollContainer/VBoxContainer/Stats/AgilityContainer/SpinBox
@onready var intelligence_spinbox = $ScrollContainer/VBoxContainer/Stats/IntelligenceContainer/SpinBox
@onready var charisma_spinbox = $ScrollContainer/VBoxContainer/Stats/CharismaContainer/SpinBox
@onready var arcane_spinbox = $ScrollContainer/VBoxContainer/Stats/ArcaneContainer/SpinBox

# Labels
@onready var stat_points_label = $ScrollContainer/VBoxContainer/Stats/StatPointsLabel
@onready var skill_points_label = $ScrollContainer/VBoxContainer/Skills/SkillPointsLabel
@onready var class_description_label = $ScrollContainer/VBoxContainer/ClassSelection/DescriptionLabel

# Buttons
@onready var back_button = $ScrollContainer/VBoxContainer/ButtonContainer/BackButton
@onready var create_button = $ScrollContainer/VBoxContainer/ButtonContainer/CreateButton
@onready var reset_button = $ScrollContainer/VBoxContainer/ButtonContainer/ResetButton

# Skills container
@onready var skills_container = $ScrollContainer/VBoxContainer/Skills/SkillsContainer

# Secondary stats display
@onready var secondary_stats_container = $ScrollContainer/VBoxContainer/SecondaryStats/StatsContainer

func _ready():
	_initialize_character_classes()
	_setup_ui()
	_create_new_character()

func _initialize_character_classes():
	character_classes = CharacterClass.get_all_classes()

func _setup_ui():
	# Setup class selection
	class_option_button.clear()
	for character_class in character_classes:
		class_option_button.add_item(character_class.name)
	
	# Setup race selection
	race_option_button.clear()
	race_option_button.add_item("Human")
	race_option_button.add_item("Elf")
	race_option_button.add_item("Dwarf")
	race_option_button.add_item("Halfling")
	race_option_button.add_item("Orc")
	
	# Setup gender selection
	gender_option_button.clear()
	gender_option_button.add_item("Male")
	gender_option_button.add_item("Female")
	gender_option_button.add_item("Non-binary")
	
	# Connect signals
	class_option_button.item_selected.connect(_on_class_selected)
	race_option_button.item_selected.connect(_on_race_selected)
	gender_option_button.item_selected.connect(_on_gender_selected)
	name_line_edit.text_changed.connect(_on_name_changed)
	
	# Connect stat spinbox signals
	strength_spinbox.value_changed.connect(_on_stat_changed.bind("Strength"))
	fortitude_spinbox.value_changed.connect(_on_stat_changed.bind("Fortitude"))
	agility_spinbox.value_changed.connect(_on_stat_changed.bind("Agility"))
	intelligence_spinbox.value_changed.connect(_on_stat_changed.bind("Intelligence"))
	charisma_spinbox.value_changed.connect(_on_stat_changed.bind("Charisma"))
	arcane_spinbox.value_changed.connect(_on_stat_changed.bind("Arcane"))
	
	# Connect buttons
	back_button.pressed.connect(_on_back_to_menu)
	create_button.pressed.connect(_on_create_character)
	reset_button.pressed.connect(_on_reset_character)
	
	# Setup skill UI
	_setup_skills_ui()

func _create_new_character():
	current_character = Character.new()
	current_character.name = "New Character"
	_apply_class_selection(0)  # Default to first class
	_update_ui()

func _setup_skills_ui():
	# Clear existing skill controls
	for child in skills_container.get_children():
		child.queue_free()
	
	# Wait for frame to ensure children are freed
	await get_tree().process_frame
	
	# Create skill controls grouped by category
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
	
	for category in skill_categories:
		var category_label = Label.new()
		category_label.text = category
		category_label.add_theme_font_size_override("font_size", 16)
		skills_container.add_child(category_label)
		
		for skill in skill_categories[category]:
			var skill_container = HBoxContainer.new()
			
			var skill_label = Label.new()
			skill_label.text = skill
			skill_label.custom_minimum_size.x = 150
			skill_container.add_child(skill_label)
			
			var skill_spinbox = SpinBox.new()
			skill_spinbox.min_value = 0
			skill_spinbox.max_value = 10
			skill_spinbox.value = current_character.skills.get(skill, 0)
			skill_spinbox.value_changed.connect(_on_skill_changed.bind(skill))
			skill_container.add_child(skill_spinbox)
			skills_container.add_child(skill_container)

func apply_class_specific_setup(class_name: String):
	# Apply class-specific UI adjustments or highlights and provide useful feedback
	match class_name:
		"Warrior":
			print("Selected Warrior - emphasizing Strength and Fortitude")
			# Highlight strength and fortitude stats
			if strength_spinbox:
				strength_spinbox.modulate = Color.LIGHT_GREEN
			if fortitude_spinbox:
				fortitude_spinbox.modulate = Color.LIGHT_GREEN
		"Wizard":
			print("Selected Wizard - emphasizing Intelligence and Arcane")
			if intelligence_spinbox:
				intelligence_spinbox.modulate = Color.LIGHT_BLUE
			if arcane_spinbox:
				arcane_spinbox.modulate = Color.LIGHT_BLUE
		"Thief":
			print("Selected Thief - emphasizing Agility and Stealth")
			if agility_spinbox:
				agility_spinbox.modulate = Color.YELLOW
		"Paladin":
			print("Selected Paladin - emphasizing Strength, Fortitude, and Charisma")
			if strength_spinbox:
				strength_spinbox.modulate = Color.LIGHT_GREEN
			if fortitude_spinbox:
				fortitude_spinbox.modulate = Color.LIGHT_GREEN
			if charisma_spinbox:
				charisma_spinbox.modulate = Color.PINK
		"Barbarian":
			print("Selected Barbarian - emphasizing Strength and Fortitude")
			if strength_spinbox:
				strength_spinbox.modulate = Color.RED
			if fortitude_spinbox:
				fortitude_spinbox.modulate = Color.RED
		"Assassin":
			print("Selected Assassin - emphasizing Agility and Strength")
			if agility_spinbox:
				agility_spinbox.modulate = Color.DARK_RED
			if strength_spinbox:
				strength_spinbox.modulate = Color.DARK_RED
		"Cleric":
			print("Selected Cleric - emphasizing Charisma and Arcane")
			if charisma_spinbox:
				charisma_spinbox.modulate = Color.GOLD
			if arcane_spinbox:
				arcane_spinbox.modulate = Color.GOLD
		"Druid":
			print("Selected Druid - emphasizing Intelligence, Arcane, and Agility")
			if intelligence_spinbox:
				intelligence_spinbox.modulate = Color.GREEN
			if arcane_spinbox:
				arcane_spinbox.modulate = Color.GREEN
		"Necromancer":
			print("Selected Necromancer - emphasizing Intelligence and Arcane")
			if intelligence_spinbox:
				intelligence_spinbox.modulate = Color.PURPLE
			if arcane_spinbox:
				arcane_spinbox.modulate = Color.PURPLE
		"Warlock":
			print("Selected Warlock - emphasizing Arcane and Charisma")
			if arcane_spinbox:
				arcane_spinbox.modulate = Color.VIOLET
			if charisma_spinbox:
				charisma_spinbox.modulate = Color.VIOLET
		"Monk":
			print("Selected Monk - emphasizing Agility, Fortitude, and Strength")
			if agility_spinbox:
				agility_spinbox.modulate = Color.ORANGE
			if fortitude_spinbox:
				fortitude_spinbox.modulate = Color.ORANGE
		_:
			print("Selected class: ", class_name)
	
	# Reset other stat spinboxes to normal color
	_reset_non_highlighted_stats(class_name)

func _reset_non_highlighted_stats(class_name: String):
	"""Reset stat spinboxes that aren't highlighted for the selected class"""
	# First reset all to white
	var all_spinboxes = [
		strength_spinbox, fortitude_spinbox, agility_spinbox,
		intelligence_spinbox, charisma_spinbox, arcane_spinbox
	]
	
	for spinbox in all_spinboxes:
		if spinbox:
			spinbox.modulate = Color.WHITE

func _on_class_selected(index: int):
	_apply_class_selection(index)
	_update_ui()

func _apply_class_selection(index: int):
	if index >= 0 and index < character_classes.size():
		var selected_class = character_classes[index]
		current_character.apply_class_bonuses(selected_class)
		class_description_label.text = selected_class.description
		
		# Reset available points
		available_stat_points = 20
		available_skill_points = 10

func _on_race_selected(index: int):
	match index:
		0: current_character.race = "Human"
		1: current_character.race = "Elf"
		2: current_character.race = "Dwarf"
		3: current_character.race = "Halfling"
		4: current_character.race = "Orc"

func _on_gender_selected(index: int):
	match index:
		0: current_character.gender = "Male"
		1: current_character.gender = "Female"
		2: current_character.gender = "Non-binary"

func _on_name_changed(new_text: String):
	current_character.name = new_text

func _on_stat_changed(stat_name: String, new_value: float):
	var old_value = current_character.primary_stats.get(stat_name, 10)
	var difference = int(new_value) - old_value
	
	if available_stat_points >= difference:
		current_character.primary_stats[stat_name] = int(new_value)
		available_stat_points -= difference
		current_character._calculate_secondary_stats()
		_update_ui()
	else:
		# Revert to old value if not enough points
		_update_stat_spinboxes()

func _on_skill_changed(skill_name: String, new_value: float):
	var old_value = current_character.skills.get(skill_name, 0)
	var difference = int(new_value) - old_value
	
	if available_skill_points >= difference:
		current_character.skills[skill_name] = int(new_value)
		available_skill_points -= difference
		current_character._calculate_secondary_stats()
		_update_ui()
	else:
		# Revert to old value if not enough points
		_update_skills_ui_values()

func _update_ui():
	_update_stat_spinboxes()
	_update_skills_ui_values()
	_update_secondary_stats_display()
	stat_points_label.text = "Available Stat Points: " + str(available_stat_points)
	skill_points_label.text = "Available Skill Points: " + str(available_skill_points)
	
	# Enable/disable create button
	create_button.disabled = current_character.name.is_empty()

func _update_stat_spinboxes():
	strength_spinbox.value = current_character.primary_stats.get("Strength", 10)
	fortitude_spinbox.value = current_character.primary_stats.get("Fortitude", 10)
	agility_spinbox.value = current_character.primary_stats.get("Agility", 10)
	intelligence_spinbox.value = current_character.primary_stats.get("Intelligence", 10)
	charisma_spinbox.value = current_character.primary_stats.get("Charisma", 10)
	arcane_spinbox.value = current_character.primary_stats.get("Arcane", 10)

func _update_skills_ui_values():
	for child in skills_container.get_children():
		if child is HBoxContainer:
			var spinbox = child.get_child(1) as SpinBox
			if spinbox:
				var skill_label = child.get_child(0) as Label
				if skill_label:
					var skill_name = skill_label.text
					spinbox.value = current_character.skills.get(skill_name, 0)

func _update_secondary_stats_display():
	# Clear existing secondary stats display
	for child in secondary_stats_container.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	# Display important secondary stats
	var important_stats = [
		"Speed", "Carry Capacity", "Dodge", "Accuracy", "Critical Chance",
		"Armor Rating", "Magic Resistance", "Perception", "Stealth", 
		"HP Regeneration", "MP Regeneration", "Spell Power", "Healing Power"
	]
	
	for stat in important_stats:
		var stat_container = HBoxContainer.new()
		
		var stat_label = Label.new()
		stat_label.text = stat + ":"
		stat_label.custom_minimum_size.x = 120
		stat_container.add_child(stat_label)
		
		var value_label = Label.new()
		value_label.text = str(current_character.secondary_stats.get(stat, 0))
		stat_container.add_child(value_label)
		
		secondary_stats_container.add_child(stat_container)

func _on_create_character():
	# Validate character is ready
	if current_character.name.length() == 0:
		print("Please enter a character name")
		# TODO: Show proper error dialog
		return
	
	# Additional validation could be added here
	# e.g., check if stat points are properly allocated
	
	# Character creation complete
	print("Character created: ", current_character.name)
	print("Class: ", current_character.character_class)
	print("Race: ", current_character.race)
	print("Gender: ", current_character.gender)
	print("Stats: ", current_character.primary_stats)
	print("Skills: ", current_character.skills)
	print("Secondary Stats: ", current_character.secondary_stats)
	print("Gold: ", current_character.gold)
	print("HP: ", current_character.health, "/", current_character.max_health)
	print("MP: ", current_character.mana, "/", current_character.max_mana)
	
	# Save character to global game state
	GameState.set_current_character(current_character)
	
	# Transition to the tavern scene
	get_tree().change_scene_to_file("res://scenes/Tavern.tscn")

func _on_back_to_menu():
	# Return to the main menu
	print("Returning to main menu...")
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _on_reset_character():
	_create_new_character()