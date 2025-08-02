extends Control

# Refactored Character Creation Screen
# Uses focused managers for different concerns and improved architecture

# Managers
var stat_manager: StatManager
var skill_manager: SkillManager
var class_highlighter: ClassHighlighter
var validator: CharacterValidator

# Data
var character_classes: Array[CharacterClass] = []
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

# Skill UI components (dynamically created)
var skill_spinboxes: Dictionary = {}

func _ready():
	_initialize_managers()
	_initialize_character_classes()
	_setup_ui()
	_create_new_character()

func _initialize_managers():
	"""Initialize all manager instances"""
	current_character = Character.new()
	stat_manager = StatManager.new(current_character)
	skill_manager = SkillManager.new(current_character)
	class_highlighter = ClassHighlighter.new()
	validator = CharacterValidator.new()
	
	# Connect manager signals
	stat_manager.stat_points_changed.connect(_on_stat_points_changed)
	stat_manager.stat_values_changed.connect(_on_stat_values_changed)
	skill_manager.skill_points_changed.connect(_on_skill_points_changed)
	skill_manager.skill_values_changed.connect(_on_skill_values_changed)

func _initialize_character_classes():
	"""Initialize available character classes"""
	character_classes = CharacterClass.get_all_classes()

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
	var skill_categories = skill_manager.get_skill_categories()
	
	for category in skill_categories:
		_create_skill_category(category, skill_categories[category])

func _create_skill_category(category_name: String, skills: Array):
	"""Create UI for a skill category"""
	# Category label
	var category_label = Label.new()
	category_label.text = category_name
	category_label.add_theme_font_size_override("font_size", 16)
	skills_container.add_child(category_label)
	
	# Skills in category
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
	skill_spinbox.value = skill_manager.get_skill_value(skill_name)
	skill_spinbox.value_changed.connect(_on_skill_changed.bind(skill_name))
	skill_container.add_child(skill_spinbox)
	
	# Store reference
	skill_spinboxes[skill_name] = skill_spinbox
	
	skills_container.add_child(skill_container)

func _create_new_character():
	"""Create a new character with default values"""
	current_character = Character.new()
	current_character.name = ""
	
	# Update managers
	stat_manager.set_character(current_character)
	skill_manager.set_character(current_character)
	
	# Apply default class
	_apply_class_selection(0)
	_update_ui()

func _apply_class_selection(index: int):
	"""Apply selected class bonuses"""
	if index >= 0 and index < character_classes.size():
		var selected_class = character_classes[index]
		
		# Apply class to character
		current_character.apply_class_bonuses(selected_class)
		
		# Update managers
		stat_manager.apply_class_bonuses(selected_class)
		skill_manager.apply_class_bonuses(selected_class)
		
		# Update UI
		class_description_label.text = selected_class.description
		class_highlighter.apply_highlighting(selected_class.name, stat_spinboxes)

# Signal Handlers - Manager Signals
func _on_stat_points_changed(available_points: int):
	"""Handle stat points change from StatManager"""
	stat_points_label.text = "Available Stat Points: " + str(available_points)

func _on_stat_values_changed(stats: Dictionary):
	"""Handle stat values change from StatManager"""
	_update_stat_spinboxes()
	_update_secondary_stats_display()

func _on_skill_points_changed(available_points: int):
	"""Handle skill points change from SkillManager"""
	skill_points_label.text = "Available Skill Points: " + str(available_points)

func _on_skill_values_changed(skills: Dictionary):
	"""Handle skill values change from SkillManager"""
	_update_skill_spinboxes()
	_update_secondary_stats_display()

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
	"""Handle stat change"""
	if not stat_manager.change_stat(stat_name, int(new_value)):
		# Revert to old value if change failed
		_update_stat_spinboxes()

func _on_skill_changed(skill_name: String, new_value: float):
	"""Handle skill change"""
	if not skill_manager.change_skill(skill_name, int(new_value)):
		# Revert to old value if change failed
		_update_skill_spinboxes()

# UI Update Methods
func _update_ui():
	"""Update all UI elements"""
	_update_stat_spinboxes()
	_update_skill_spinboxes()
	_update_secondary_stats_display()
	_update_create_button_state()

func _update_stat_spinboxes():
	"""Update stat spinbox values"""
	for stat_name in stat_spinboxes:
		var spinbox = stat_spinboxes[stat_name]
		if spinbox:
			spinbox.value = stat_manager.get_stat_value(stat_name)

func _update_skill_spinboxes():
	"""Update skill spinbox values"""
	for skill_name in skill_spinboxes:
		var spinbox = skill_spinboxes[skill_name]
		if spinbox:
			spinbox.value = skill_manager.get_skill_value(skill_name)

func _update_secondary_stats_display():
	"""Update secondary stats display"""
	# Clear existing display
	for child in secondary_stats_container.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	# Important secondary stats to display
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

func _update_create_button_state():
	"""Update create button enabled state"""
	var validation_result = validator.validate_character(current_character, stat_manager, skill_manager)
	create_button.disabled = not validation_result.valid
	
	# Could show validation message in a label if desired
	if not validation_result.valid:
		create_button.tooltip_text = validation_result.message
	else:
		create_button.tooltip_text = ""

# Button Handlers
func _on_create_character():
	"""Handle character creation"""
	var validation_result = validator.validate_character(current_character, stat_manager, skill_manager)
	
	if not validation_result.valid:
		print("Character creation failed: ", validation_result.message)
		# Could show error dialog here
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
	print("  Gold: ", current_character.gold)
	
	# Save character to game state
	GameState.set_current_character(current_character)
	
	# Transition to tavern
	get_tree().change_scene_to_file("res://scenes/Tavern.tscn")

func _on_back_to_menu():
	"""Return to main menu"""
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _on_reset_character():
	"""Reset character to defaults"""
	_create_new_character()