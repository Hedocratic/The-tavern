extends Control

# Simple Character Creation Screen - Working Demo
# Simplified version without complex manager dependencies

# Data
var character_classes: Array = []
var current_character: Character

# UI References - Basic Info
@onready var name_line_edit = $ScrollContainer/VBoxContainer/CharacterName/LineEdit
@onready var class_option_button = $ScrollContainer/VBoxContainer/ClassSelection/OptionButton
@onready var race_option_button = $ScrollContainer/VBoxContainer/RaceSelection/OptionButton
@onready var gender_option_button = $ScrollContainer/VBoxContainer/GenderSelection/OptionButton
@onready var class_description_label = $ScrollContainer/VBoxContainer/ClassSelection/DescriptionLabel

# UI References - Stats
@onready var stat_spinboxes = {
	"Strength": $ScrollContainer/VBoxContainer/Stats/StrengthContainer/SpinBox,
	"Fortitude": $ScrollContainer/VBoxContainer/Stats/FortitudeContainer/SpinBox,
	"Agility": $ScrollContainer/VBoxContainer/Stats/AgilityContainer/SpinBox,
	"Intelligence": $ScrollContainer/VBoxContainer/Stats/IntelligenceContainer/SpinBox,
	"Charisma": $ScrollContainer/VBoxContainer/Stats/CharismaContainer/SpinBox,
	"Arcane": $ScrollContainer/VBoxContainer/Stats/ArcaneContainer/SpinBox
}

# UI References - Labels and Controls
@onready var stat_points_label = $ScrollContainer/VBoxContainer/Stats/StatPointsLabel
@onready var skill_points_label = $ScrollContainer/VBoxContainer/Skills/SkillPointsLabel
@onready var skills_container = $ScrollContainer/VBoxContainer/Skills/SkillsContainer
@onready var secondary_stats_container = $ScrollContainer/VBoxContainer/SecondaryStats/StatsContainer

# UI References - Buttons
@onready var back_button = $ScrollContainer/VBoxContainer/ButtonContainer/BackButton
@onready var create_button = $ScrollContainer/VBoxContainer/ButtonContainer/CreateButton
@onready var reset_button = $ScrollContainer/VBoxContainer/ButtonContainer/ResetButton

# Simple stat and skill management
var available_stat_points: int = 20
var available_skill_points: int = 10
var skill_spinboxes: Dictionary = {}

func _ready():
	_initialize_character_classes()
	_setup_ui()
	_create_new_character()

func _initialize_character_classes():
	"""Initialize character classes without complex dependencies"""
	character_classes = [
		{
			"name": "Warrior",
			"description": "A strong melee fighter focused on Strength and Fortitude.",
			"stats": {"Strength": 16, "Fortitude": 15, "Agility": 12, "Intelligence": 8, "Charisma": 10, "Arcane": 6}
		},
		{
			"name": "Wizard",
			"description": "A master of arcane magic, emphasizing Intelligence and Arcane power.",
			"stats": {"Strength": 8, "Fortitude": 10, "Agility": 11, "Intelligence": 16, "Charisma": 12, "Arcane": 15}
		},
		{
			"name": "Thief",
			"description": "A nimble character skilled in stealth and agility.",
			"stats": {"Strength": 10, "Fortitude": 11, "Agility": 16, "Intelligence": 13, "Charisma": 12, "Arcane": 8}
		},
		{
			"name": "Paladin",
			"description": "A holy warrior balancing strength, faith, and leadership.",
			"stats": {"Strength": 15, "Fortitude": 14, "Agility": 10, "Intelligence": 11, "Charisma": 15, "Arcane": 12}
		}
	]

func _setup_ui():
	"""Setup UI components and connect signals"""
	_setup_class_selection()
	_setup_race_selection()
	_setup_gender_selection()
	_setup_stat_controls()
	_setup_button_connections()
	_setup_skills_ui()

func _setup_class_selection():
	"""Setup class selection dropdown"""
	class_option_button.clear()
	for character_class in character_classes:
		class_option_button.add_item(character_class.name)
	
	class_option_button.item_selected.connect(_on_class_selected)

func _setup_race_selection():
	"""Setup race selection dropdown"""
	var races = ["Human", "Elf", "Dwarf", "Halfling", "Orc"]
	race_option_button.clear()
	for race in races:
		race_option_button.add_item(race)
	
	race_option_button.item_selected.connect(_on_race_selected)

func _setup_gender_selection():
	"""Setup gender selection dropdown"""
	var genders = ["Male", "Female", "Non-binary"]
	gender_option_button.clear()
	for gender in genders:
		gender_option_button.add_item(gender)
	
	gender_option_button.item_selected.connect(_on_gender_selected)

func _setup_stat_controls():
	"""Setup stat spinboxes and connect signals"""
	for stat_name in stat_spinboxes:
		var spinbox = stat_spinboxes[stat_name]
		if spinbox:
			spinbox.min_value = 1
			spinbox.max_value = 25
			spinbox.value_changed.connect(_on_stat_changed.bind(stat_name))
	
	if name_line_edit:
		name_line_edit.text_changed.connect(_on_name_changed)

func _setup_button_connections():
	"""Connect button signals"""
	back_button.pressed.connect(_on_back_to_menu)
	create_button.pressed.connect(_on_create_character)
	reset_button.pressed.connect(_on_reset_character)

func _setup_skills_ui():
	"""Setup dynamic skills UI"""
	# Clear existing skill controls
	for child in skills_container.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	skill_spinboxes.clear()
	
	# Simple skill list for demo
	var skills = [
		"Slashing Weapons", "Blunt Weapons", "Archery", "Heavy Armor", "Light Armor",
		"Evocation", "Restoration", "Arcane Knowledge", "Stealth", "Lockpicking",
		"Persuasion", "Intimidation", "Survival", "First Aid", "Leadership"
	]
	
	for skill in skills:
		_create_skill_control(skill)

func _create_skill_control(skill_name: String):
	"""Create UI control for a single skill"""
	var skill_container = HBoxContainer.new()
	
	# Skill label
	var skill_label = Label.new()
	skill_label.text = skill_name
	skill_label.custom_minimum_size.x = 150
	skill_container.add_child(skill_label)
	
	# Skill spinbox
	var skill_spinbox = SpinBox.new()
	skill_spinbox.min_value = 0
	skill_spinbox.max_value = 10
	skill_spinbox.value = 0
	skill_spinbox.value_changed.connect(_on_skill_changed.bind(skill_name))
	skill_container.add_child(skill_spinbox)
	
	# Store reference
	skill_spinboxes[skill_name] = skill_spinbox
	
	skills_container.add_child(skill_container)

func _create_new_character():
	"""Create a new character with default values"""
	current_character = Character.new()
	current_character.name = ""
	
	# Apply default class (first one)
	_apply_class_selection(0)
	_update_ui()

func _apply_class_selection(index: int):
	"""Apply selected class bonuses"""
	if index < 0 or index >= character_classes.size():
		return
		
	var selected_class = character_classes[index]
	current_character.character_class = selected_class.name
	
	# Apply class stats
	for stat_name in selected_class.stats:
		current_character.primary_stats[stat_name] = selected_class.stats[stat_name]
	
	# Update description
	class_description_label.text = selected_class.description
	
	# Recalculate available points
	available_stat_points = 20
	available_skill_points = 10

# Signal Handlers - UI Events
func _on_class_selected(index: int):
	"""Handle class selection"""
	_apply_class_selection(index)

func _on_race_selected(index: int):
	"""Handle race selection"""
	var races = ["Human", "Elf", "Dwarf", "Halfling", "Orc"]
	if index >= 0 and index < races.size():
		current_character.race = races[index]

func _on_gender_selected(index: int):
	"""Handle gender selection"""
	var genders = ["Male", "Female", "Non-binary"]
	if index >= 0 and index < genders.size():
		current_character.gender = genders[index]

func _on_name_changed(new_text: String):
	"""Handle name change"""
	current_character.name = new_text
	_update_create_button_state()

func _on_stat_changed(stat_name: String, new_value: float):
	"""Handle stat change with point management"""
	var old_value = current_character.primary_stats.get(stat_name, 10)
	var difference = int(new_value) - old_value
	
	if available_stat_points >= difference:
		current_character.primary_stats[stat_name] = int(new_value)
		available_stat_points -= difference
		current_character._calculate_secondary_stats()
		_update_stat_points_display()
		_update_secondary_stats_display()
	else:
		# Revert to old value
		var spinbox = stat_spinboxes[stat_name]
		spinbox.value = old_value

func _on_skill_changed(skill_name: String, new_value: float):
	"""Handle skill change with point management"""
	var old_value = current_character.skills.get(skill_name, 0)
	var difference = int(new_value) - old_value
	
	if available_skill_points >= difference:
		current_character.skills[skill_name] = int(new_value)
		available_skill_points -= difference
		_update_skill_points_display()
	else:
		# Revert to old value
		var spinbox = skill_spinboxes[skill_name]
		spinbox.value = old_value

# UI Update Methods
func _update_ui():
	"""Update all UI elements"""
	_update_stat_spinboxes()
	_update_skill_spinboxes()
	_update_stat_points_display()
	_update_skill_points_display()
	_update_secondary_stats_display()
	_update_create_button_state()

func _update_stat_spinboxes():
	"""Update stat spinbox values"""
	for stat_name in stat_spinboxes:
		var spinbox = stat_spinboxes[stat_name]
		if spinbox:
			spinbox.value = current_character.primary_stats.get(stat_name, 10)

func _update_skill_spinboxes():
	"""Update skill spinbox values"""
	for skill_name in skill_spinboxes:
		var spinbox = skill_spinboxes[skill_name]
		if spinbox:
			spinbox.value = current_character.skills.get(skill_name, 0)

func _update_stat_points_display():
	"""Update stat points label"""
	stat_points_label.text = "Available Stat Points: " + str(available_stat_points)

func _update_skill_points_display():
	"""Update skill points label"""
	skill_points_label.text = "Available Skill Points: " + str(available_skill_points)

func _update_secondary_stats_display():
	"""Update secondary stats display"""
	# Clear existing display
	for child in secondary_stats_container.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	# Display important secondary stats
	var important_stats = [
		"Speed", "Carry Capacity", "Dodge", "Accuracy", "Critical Chance",
		"Armor Rating", "Magic Resistance", "HP Regeneration", "MP Regeneration"
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

func _update_create_button_state():
	"""Update create button enabled state"""
	var is_valid = not current_character.name.is_empty() and current_character.name.strip_edges().length() > 0
	create_button.disabled = not is_valid

# Button Handlers
func _on_create_character():
	"""Handle character creation"""
	if current_character.name.is_empty():
		print("Please enter a character name")
		return
	
	print("Character created successfully:")
	print("  Name: ", current_character.name)
	print("  Class: ", current_character.character_class)
	print("  Race: ", current_character.race)
	print("  Gender: ", current_character.gender)
	print("  Stats: ", current_character.primary_stats)
	print("  Skills: ", current_character.skills)
	print("  HP: ", current_character.health, "/", current_character.max_health)
	print("  MP: ", current_character.mana, "/", current_character.max_mana)
	
	# Save character to game state
	if GameState:
		GameState.set_current_character(current_character)
	
	# Transition to tavern
	get_tree().change_scene_to_file("res://scenes/Tavern.tscn")

func _on_back_to_menu():
	"""Return to main menu"""
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _on_reset_character():
	"""Reset character to defaults"""
	_create_new_character()