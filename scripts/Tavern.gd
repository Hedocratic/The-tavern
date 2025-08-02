extends Control

# Tavern Scene - Main hub for the player
# This is where players will manage their party, equipment, and start adventures

# UI References
@onready var situation_overlay = $SituationOverlay
@onready var tavern_main = $TavernMain
@onready var welcome_label = $SituationOverlay/Panel/VBoxContainer/WelcomeLabel
@onready var situation_text = $SituationOverlay/Panel/VBoxContainer/SituationText
@onready var continue_button = $SituationOverlay/Panel/VBoxContainer/ContinueButton

# Tavern UI elements
@onready var tavern_name = $TavernMain/VBoxContainer/TavernHeader/TavernName
@onready var character_info = $TavernMain/VBoxContainer/MainContent/LeftPanel/CharacterInfo
@onready var party_list = $TavernMain/VBoxContainer/MainContent/LeftPanel/PartyPanel/PartyList
@onready var tavern_menu = $TavernMain/VBoxContainer/MainContent/RightPanel/TavernMenu

# Character data
var current_character: Character
var party_members: Array[Character] = []

func _ready():
	# Get character from global state
	current_character = GameState.get_current_character()
	party_members = GameState.get_party()
	
	# Show the situation overlay first
	situation_overlay.visible = true
	tavern_main.visible = false
	
	# Setup the situation explanation
	_setup_situation_overlay()
	
	# Connect signals
	continue_button.pressed.connect(_on_continue_pressed)
	
	# Setup tavern UI (but keep it hidden initially)
	_setup_tavern_ui()

func _setup_situation_overlay():
	"""Setup the initial text overlay explaining the situation"""
	welcome_label.text = "Welcome to The Rusty Dragon Tavern!"
	
	# Placeholder text as requested in the problem statement
	situation_text.text = """
You find yourself in the bustling common room of The Rusty Dragon, 
a well-known tavern at the crossroads of adventure. The air is thick 
with the scent of roasted meat and ale, and the warmth of the hearth 
drives away the chill of the night.

Tales of ancient dungeons, lost treasures, and fearsome monsters 
fill the conversations around you. This tavern serves as a gathering 
place for adventurers seeking fame, fortune, and glory.

As a newly arrived adventurer, you must prepare yourself for the 
challenges ahead. Here you can:

• Rest and recover your strength
• Recruit companions for your journey  
• Purchase equipment and supplies
• Learn about local quests and opportunities
• Plan your next adventure

The barkeep nods at you knowingly - another soul seeking adventure 
has arrived. What will your story become?
"""

func _setup_tavern_ui():
	"""Setup the main tavern interface"""
	tavern_name.text = "The Rusty Dragon Tavern"
	
	# Setup character info panel
	if current_character:
		_update_character_display()
	
	# Setup tavern menu options
	_create_tavern_menu()

func _create_tavern_menu():
	"""Create the tavern menu options"""
	# Clear existing menu items
	for child in tavern_menu.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	# Create menu options
	var menu_options = [
		{"text": "Rest & Recover", "action": "_on_rest_selected"},
		{"text": "Manage Party", "action": "_on_party_selected"},
		{"text": "Visit Shop", "action": "_on_shop_selected"},
		{"text": "Local Quests", "action": "_on_quests_selected"},
		{"text": "Character Sheet", "action": "_on_character_sheet_selected"},
		{"text": "Create New Character", "action": "_on_new_character"},
		{"text": "Leave Tavern", "action": "_on_leave_tavern"}
	]
	
	for option in menu_options:
		var button = Button.new()
		button.text = option.text
		button.custom_minimum_size.y = 40
		button.pressed.connect(Callable(self, option.action))
		tavern_menu.add_child(button)

func _update_character_display():
	"""Update the character information display"""
	if not current_character:
		return
		
	# Clear existing character info
	for child in character_info.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	# Character name and class
	var name_label = Label.new()
	name_label.text = current_character.name + " (" + current_character.character_class + ")"
	name_label.add_theme_font_size_override("font_size", 18)
	character_info.add_child(name_label)
	
	# Health and Mana
	var health_label = Label.new()
	health_label.text = "Health: " + str(current_character.health) + "/" + str(current_character.max_health)
	character_info.add_child(health_label)
	
	var mana_label = Label.new()
	mana_label.text = "Mana: " + str(current_character.mana) + "/" + str(current_character.max_mana)
	character_info.add_child(mana_label)
	
	# Gold
	var gold_label = Label.new()
	gold_label.text = "Gold: " + str(current_character.gold)
	character_info.add_child(gold_label)

func set_character(character: Character):
	"""Set the current character"""
	current_character = character
	if party_members.is_empty():
		party_members.append(character)
	_update_character_display()

func _on_continue_pressed():
	"""Hide the situation overlay and show the tavern UI"""
	situation_overlay.visible = false
	tavern_main.visible = true

# Tavern menu action functions (placeholder implementations)
func _on_rest_selected():
	print("Rest & Recover selected - restore health and mana")
	if current_character:
		current_character.health = current_character.max_health
		current_character.mana = current_character.max_mana
		_update_character_display()

func _on_party_selected():
	print("Manage Party selected - add/remove party members")
	# TODO: Implement party management UI

func _on_shop_selected():
	print("Visit Shop selected - buy/sell equipment")
	# TODO: Implement shop UI

func _on_quests_selected():
	print("Local Quests selected - view available quests")
	# TODO: Implement quest board UI

func _on_character_sheet_selected():
	print("Character Sheet selected - view detailed character info")
	# TODO: Implement detailed character sheet UI

func _on_new_character():
	print("Create New Character selected - returning to character creation")
	get_tree().change_scene_to_file("res://scenes/CharacterCreation.tscn")

func _on_leave_tavern():
	print("Leave Tavern selected - go to world map or adventure")
	# TODO: Implement world map or direct adventure start
