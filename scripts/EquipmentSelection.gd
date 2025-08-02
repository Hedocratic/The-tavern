extends Control

# Equipment Selection - Shop-like interface for buying basic equipment

# UI References
@onready var gold_label = $VBoxContainer/Header/GoldLabel
@onready var equipment_categories = $VBoxContainer/Content/EquipmentCategories
@onready var equipment_list = $VBoxContainer/Content/HBoxContainer/EquipmentList/ScrollContainer/ItemList
@onready var item_details = $VBoxContainer/Content/HBoxContainer/ItemDetails/Details
@onready var buy_button = $VBoxContainer/Content/HBoxContainer/ItemDetails/BuyButton
@onready var inventory_list = $VBoxContainer/Content/HBoxContainer/InventoryPanel/ScrollContainer2/InventoryList
@onready var total_weight_label = $VBoxContainer/Content/HBoxContainer/InventoryPanel/WeightLabel
@onready var back_button = $VBoxContainer/ButtonSection/BackButton

# Data
var current_character: Character
var available_equipment: Array[Equipment] = []
var selected_item: Equipment
var character_inventory: Array[Equipment] = []

# Equipment categories
var equipment_categories_data = {
	"All": [],
	"Tools": [],
	"Weapons": [],
	"Armor": [],
	"Consumables": []
}

func _ready():
	current_character = GameState.get_current_character()
	
	if not current_character:
		print("No character found")
		_return_to_tavern()
		return
	
	_load_equipment()
	_setup_ui()
	
	# Connect signals
	back_button.pressed.connect(_return_to_tavern)
	buy_button.pressed.connect(_buy_selected_item)

func _load_equipment():
	"""Load all available equipment"""
	# Get all equipment types
	var basic_equipment = Equipment.get_basic_equipment()
	var weapons = Equipment.get_weapons()
	var armor = Equipment.get_armor()
	
	available_equipment = basic_equipment + weapons + armor
	
	# Organize by category
	equipment_categories_data["All"] = available_equipment
	
	for item in available_equipment:
		match item.category:
			"Tool":
				equipment_categories_data["Tools"].append(item)
			"Weapon":
				equipment_categories_data["Weapons"].append(item)
			"Armor":
				equipment_categories_data["Armor"].append(item)
			"Consumable":
				equipment_categories_data["Consumables"].append(item)

func _setup_ui():
	"""Setup the equipment selection UI"""
	_update_gold_display()
	_setup_category_tabs()
	_setup_equipment_list("All")
	_setup_inventory_display()
	_update_buy_button()

func _update_gold_display():
	"""Update the gold display"""
	gold_label.text = "Gold: " + str(current_character.gold)

func _setup_category_tabs():
	"""Setup category selection tabs"""
	# Clear existing tabs
	for child in equipment_categories.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	# Create category buttons
	for category in equipment_categories_data:
		var button = Button.new()
		button.text = category
		button.toggle_mode = true
		button.button_group = ButtonGroup.new() if not equipment_categories.get_child_count() else equipment_categories.get_child(0).button_group
		button.pressed.connect(_on_category_selected.bind(category))
		
		if category == "All":
			button.button_pressed = true
			
		equipment_categories.add_child(button)

func _on_category_selected(category: String):
	"""Handle category selection"""
	_setup_equipment_list(category)

func _setup_equipment_list(category: String):
	"""Setup the equipment list for selected category"""
	# Clear existing list
	for child in equipment_list.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	# Add equipment items
	var items = equipment_categories_data[category]
	for item in items:
		var item_container = HBoxContainer.new()
		
		# Item button
		var item_button = Button.new()
		item_button.text = item.name + " (" + str(item.cost) + " gold)"
		item_button.custom_minimum_size.x = 300
		item_button.pressed.connect(_on_item_selected.bind(item))
		item_container.add_child(item_button)
		
		# Weight label
		var weight_label = Label.new()
		weight_label.text = str(item.weight) + " lbs"
		weight_label.custom_minimum_size.x = 60
		item_container.add_child(weight_label)
		
		equipment_list.add_child(item_container)

func _on_item_selected(item: Equipment):
	"""Handle item selection"""
	selected_item = item
	_update_item_details()
	_update_buy_button()

func _update_item_details():
	"""Update the item details panel"""
	if not selected_item:
		item_details.text = "Select an item to see details"
		return
	
	var details_text = ""
	details_text += "Name: " + selected_item.name + "\n"
	details_text += "Category: " + selected_item.category + "\n"
	details_text += "Cost: " + str(selected_item.cost) + " gold\n"
	details_text += "Weight: " + str(selected_item.weight) + " lbs\n\n"
	details_text += "Description:\n" + selected_item.description + "\n"
	
	if selected_item.stat_modifiers.size() > 0:
		details_text += "\nStat Modifiers:\n"
		for stat in selected_item.stat_modifiers:
			var modifier = selected_item.stat_modifiers[stat]
			details_text += "  " + stat + ": " + ("+" if modifier >= 0 else "") + str(modifier) + "\n"
	
	if selected_item.special_effects.size() > 0:
		details_text += "\nSpecial Effects:\n"
		for effect in selected_item.special_effects:
			details_text += "  • " + effect + "\n"
	
	item_details.text = details_text

func _update_buy_button():
	"""Update the buy button state"""
	if not selected_item:
		buy_button.disabled = true
		buy_button.text = "Select Item"
		return
	
	var can_afford = current_character.gold >= selected_item.cost
	var carry_capacity = current_character.secondary_stats.get("Carry Capacity", 20)
	var current_weight = _calculate_current_weight()
	var can_carry = (current_weight + selected_item.weight) <= carry_capacity
	
	if not can_afford:
		buy_button.disabled = true
		buy_button.text = "Cannot Afford"
	elif not can_carry:
		buy_button.disabled = true
		buy_button.text = "Too Heavy"
	else:
		buy_button.disabled = false
		buy_button.text = "Buy " + selected_item.name

func _buy_selected_item():
	"""Buy the selected item"""
	if not selected_item or current_character.gold < selected_item.cost:
		return
	
	# Check carry capacity
	var carry_capacity = current_character.secondary_stats.get("Carry Capacity", 20)
	var current_weight = _calculate_current_weight()
	if (current_weight + selected_item.weight) > carry_capacity:
		return
	
	# Purchase item
	current_character.gold -= selected_item.cost
	character_inventory.append(selected_item)
	
	# Update current character's inventory (simplified - just store names for now)
	current_character.inventory.append(selected_item.name)
	
	# Update UI
	_update_gold_display()
	_setup_inventory_display()
	_update_buy_button()
	
	print("Purchased: " + selected_item.name)

func _setup_inventory_display():
	"""Setup the inventory display"""
	# Clear existing
	for child in inventory_list.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	# Add inventory items
	for item in character_inventory:
		var item_label = Label.new()
		item_label.text = item.name + " (" + str(item.weight) + " lbs)"
		inventory_list.add_child(item_label)
	
	# Update weight display
	var total_weight = _calculate_current_weight()
	var carry_capacity = current_character.secondary_stats.get("Carry Capacity", 20)
	total_weight_label.text = "Weight: " + str(total_weight) + "/" + str(carry_capacity) + " lbs"
	
	# Change color if overloaded
	if total_weight > carry_capacity:
		total_weight_label.add_theme_color_override("font_color", Color.RED)
	else:
		total_weight_label.remove_theme_color_override("font_color")

func _calculate_current_weight() -> float:
	"""Calculate current inventory weight"""
	var total = 0.0
	for item in character_inventory:
		total += item.weight
	return total

func _return_to_tavern():
	"""Return to tavern"""
	get_tree().change_scene_to_file("res://scenes/Tavern.tscn")