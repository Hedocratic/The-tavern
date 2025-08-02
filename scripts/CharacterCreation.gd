extends Control

# Character Creation script for The Tavern
# Handles character customization based on the Game Design Document

# References to UI elements
@onready var name_line_edit = $ScrollContainer/MainVBox/HBoxContainer/LeftPanel/BasicInfoContainer/NameContainer/NameLineEdit
@onready var race_option_button = $ScrollContainer/MainVBox/HBoxContainer/LeftPanel/BasicInfoContainer/RaceContainer/RaceOptionButton
@onready var gender_option_button = $ScrollContainer/MainVBox/HBoxContainer/LeftPanel/BasicInfoContainer/GenderContainer/GenderOptionButton
@onready var class_option_button = $ScrollContainer/MainVBox/HBoxContainer/LeftPanel/BasicInfoContainer/ClassContainer/ClassOptionButton

# Stat SpinBoxes
@onready var strength_spinbox = $ScrollContainer/MainVBox/HBoxContainer/LeftPanel/StatsContainer/StrengthContainer/StrengthSpinBox
@onready var fortitude_spinbox = $ScrollContainer/MainVBox/HBoxContainer/LeftPanel/StatsContainer/FortitudeContainer/FortitudeSpinBox
@onready var agility_spinbox = $ScrollContainer/MainVBox/HBoxContainer/LeftPanel/StatsContainer/AgilityContainer/AgilitySpinBox
@onready var intelligence_spinbox = $ScrollContainer/MainVBox/HBoxContainer/LeftPanel/StatsContainer/IntelligenceContainer/IntelligenceSpinBox
@onready var charisma_spinbox = $ScrollContainer/MainVBox/HBoxContainer/LeftPanel/StatsContainer/CharismaContainer/CharismaSpinBox
@onready var arcane_spinbox = $ScrollContainer/MainVBox/HBoxContainer/LeftPanel/StatsContainer/ArcaneContainer/ArcaneSpinBox

# Skill SpinBoxes
@onready var swimming_spinbox = $ScrollContainer/MainVBox/HBoxContainer/RightPanel/SkillsContainer/SwimmingContainer/SwimmingSpinBox
@onready var slashing_spinbox = $ScrollContainer/MainVBox/HBoxContainer/RightPanel/SkillsContainer/SlashingContainer/SlashingSpinBox
@onready var evocation_spinbox = $ScrollContainer/MainVBox/HBoxContainer/RightPanel/SkillsContainer/EvocationContainer/EvocationSpinBox
@onready var survival_spinbox = $ScrollContainer/MainVBox/HBoxContainer/RightPanel/SkillsContainer/SurvivalContainer/SurvivalSpinBox
@onready var seduction_spinbox = $ScrollContainer/MainVBox/HBoxContainer/RightPanel/SkillsContainer/SeductionContainer/SeductionSpinBox

# Equipment
@onready var weapon_option_button = $ScrollContainer/MainVBox/HBoxContainer/RightPanel/EquipmentContainer/WeaponContainer/WeaponOptionButton
@onready var armor_option_button = $ScrollContainer/MainVBox/HBoxContainer/RightPanel/EquipmentContainer/ArmorContainer/ArmorOptionButton

# Summary
@onready var summary_text = $ScrollContainer/MainVBox/HBoxContainer/RightPanel/SummaryText

# Character data structure based on GDD
var character_data = {
	"name": "",
	"class": "",
	"race": "",
	"gender": "",
	"level": 1,
	"experience": 0,
	"stats": {
		"Strength": 10,
		"Fortitude": 10,
		"Agility": 10,
		"Intelligence": 10,
		"Charisma": 10,
		"Arcane": 10
	},
	"skills": {
		"Swimming": 0,
		"Slashing": 0,
		"Evocation": 0,
		"Survival": 0,
		"Seduction": 0
	},
	"inventory": [],
	"status_effects": [],
	"buffs": [],
	"health": 100,
	"gold": 100
}

# Available stat points for allocation
var stat_points_available = 20
var skill_points_available = 10

func _ready():
	# Connect signals for real-time updates
	_connect_stat_signals()
	_connect_skill_signals()
	_connect_info_signals()
	
	# Set initial values
	_update_character_summary()

func _connect_stat_signals():
	# Connect stat spinbox value changes
	strength_spinbox.value_changed.connect(_on_stat_changed)
	fortitude_spinbox.value_changed.connect(_on_stat_changed)
	agility_spinbox.value_changed.connect(_on_stat_changed)
	intelligence_spinbox.value_changed.connect(_on_stat_changed)
	charisma_spinbox.value_changed.connect(_on_stat_changed)
	arcane_spinbox.value_changed.connect(_on_stat_changed)

func _connect_skill_signals():
	# Connect skill spinbox value changes
	swimming_spinbox.value_changed.connect(_on_skill_changed)
	slashing_spinbox.value_changed.connect(_on_skill_changed)
	evocation_spinbox.value_changed.connect(_on_skill_changed)
	survival_spinbox.value_changed.connect(_on_skill_changed)
	seduction_spinbox.value_changed.connect(_on_skill_changed)

func _connect_info_signals():
	# Connect basic info changes
	name_line_edit.text_changed.connect(_on_name_changed)
	race_option_button.item_selected.connect(_on_race_changed)
	gender_option_button.item_selected.connect(_on_gender_changed)
	class_option_button.item_selected.connect(_on_class_changed)

func _on_stat_changed(value):
	# Update character data when stats change
	character_data.stats["Strength"] = int(strength_spinbox.value)
	character_data.stats["Fortitude"] = int(fortitude_spinbox.value)
	character_data.stats["Agility"] = int(agility_spinbox.value)
	character_data.stats["Intelligence"] = int(intelligence_spinbox.value)
	character_data.stats["Charisma"] = int(charisma_spinbox.value)
	character_data.stats["Arcane"] = int(arcane_spinbox.value)
	
	_update_character_summary()

func _on_skill_changed(value):
	# Update character data when skills change
	character_data.skills["Swimming"] = int(swimming_spinbox.value)
	character_data.skills["Slashing"] = int(slashing_spinbox.value)
	character_data.skills["Evocation"] = int(evocation_spinbox.value)
	character_data.skills["Survival"] = int(survival_spinbox.value)
	character_data.skills["Seduction"] = int(seduction_spinbox.value)
	
	_update_character_summary()

func _on_name_changed(new_text):
	character_data.name = new_text
	_update_character_summary()

func _on_race_changed(index):
	character_data.race = race_option_button.get_item_text(index)
	_update_character_summary()

func _on_gender_changed(index):
	character_data.gender = gender_option_button.get_item_text(index)
	_update_character_summary()

func _on_class_changed(index):
	character_data.class = class_option_button.get_item_text(index)
	_apply_class_bonuses(character_data.class)
	_update_character_summary()

func _apply_class_bonuses(class_name):
	# Apply class-specific stat bonuses as mentioned in GDD
	# Reset to base values first
	_reset_stats_to_base()
	
	match class_name:
		"Fighter":
			strength_spinbox.value += 3
			fortitude_spinbox.value += 2
		"Rogue":
			agility_spinbox.value += 3
			intelligence_spinbox.value += 1
			charisma_spinbox.value += 1
		"Wizard":
			intelligence_spinbox.value += 3
			arcane_spinbox.value += 2
		"Cleric":
			fortitude_spinbox.value += 2
			charisma_spinbox.value += 2
			arcane_spinbox.value += 1
		"Ranger":
			agility_spinbox.value += 2
			intelligence_spinbox.value += 2
			fortitude_spinbox.value += 1
		"Bard":
			charisma_spinbox.value += 3
			intelligence_spinbox.value += 1
			agility_spinbox.value += 1

func _reset_stats_to_base():
	# Reset all stats to 10 (base value)
	strength_spinbox.value = 10
	fortitude_spinbox.value = 10
	agility_spinbox.value = 10
	intelligence_spinbox.value = 10
	charisma_spinbox.value = 10
	arcane_spinbox.value = 10

func _update_character_summary():
	# Update the character summary text
	var summary = ""
	summary += "[b]Name:[/b] " + (character_data.name if character_data.name != "" else "Unnamed") + "\n"
	summary += "[b]Race:[/b] " + character_data.race + "\n"
	summary += "[b]Gender:[/b] " + character_data.gender + "\n"
	summary += "[b]Class:[/b] " + character_data.class + "\n\n"
	
	summary += "[b]Primary Stats:[/b]\n"
	for stat in character_data.stats:
		summary += "• " + stat + ": " + str(character_data.stats[stat]) + "\n"
	
	summary += "\n[b]Skills:[/b]\n"
	for skill in character_data.skills:
		summary += "• " + skill + ": " + str(character_data.skills[skill]) + "\n"
	
	# Calculate secondary stats based on primary stats
	var speed = character_data.stats["Agility"] + 5
	var carry_capacity = character_data.stats["Strength"] * 10
	summary += "\n[b]Secondary Stats:[/b]\n"
	summary += "• Speed: " + str(speed) + "\n"
	summary += "• Carry Capacity: " + str(carry_capacity) + " lbs\n"
	
	summary_text.text = summary

func _on_back_button_pressed():
	# Return to main menu
	print("Returning to main menu")
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _on_create_button_pressed():
	# Validate character creation
	if character_data.name == "":
		print("Please enter a character name")
		return
	
	# Create the character and proceed to tavern/game
	print("Character created successfully!")
	print("Character data: ", character_data)
	
	# TODO: Save character data and proceed to tavern scene
	# For now, just return to main menu
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")