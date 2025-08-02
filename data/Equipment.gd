class_name Equipment
extends Resource

# Equipment/Item data structure

@export var name: String = ""
@export var description: String = ""
@export var category: String = ""  # "Weapon", "Armor", "Accessory", "Consumable", "Tool"
@export var weight: float = 0.0
@export var cost: int = 0
@export var stat_modifiers: Dictionary = {}  # {"Strength": 1, "Agility": -1}
@export var special_effects: Array[String] = []  # Special properties or effects

func _init(item_name: String = "", item_description: String = "", item_category: String = "", item_weight: float = 0.0, item_cost: int = 0):
	name = item_name
	description = item_description
	category = item_category
	weight = item_weight
	cost = item_cost

static func get_basic_equipment() -> Array[Equipment]:
	"""Get a list of basic adventuring equipment"""
	var equipment = []
	
	# Basic adventuring gear
	var rope = Equipment.new("Rope (50 ft)", "Strong hemp rope useful for climbing and securing items", "Tool", 10.0, 2)
	equipment.append(rope)
	
	var torches = Equipment.new("Torches (5)", "Wooden torches that provide light in dark places", "Tool", 5.0, 1)
	equipment.append(torches)
	
	var tinder = Equipment.new("Tinderbox", "Flint, steel, and tinder for starting fires", "Tool", 1.0, 5)
	equipment.append(tinder)
	
	var rations = Equipment.new("Trail Rations (3 days)", "Dried meat, hardtack, and preserved food", "Consumable", 6.0, 15)
	equipment.append(rations)
	
	var waterskin = Equipment.new("Waterskin", "Leather container for carrying water", "Tool", 4.0, 2)
	equipment.append(waterskin)
	
	var bedroll = Equipment.new("Bedroll", "Portable sleeping gear for camping", "Tool", 7.0, 1)
	equipment.append(bedroll)
	
	var backpack = Equipment.new("Backpack", "Large pack for carrying equipment", "Tool", 5.0, 2)
	backpack.special_effects.append("Increases carry capacity by 10")
	equipment.append(backpack)
	
	var lantern = Equipment.new("Lantern", "Oil lantern providing bright, steady light", "Tool", 2.0, 10)
	equipment.append(lantern)
	
	var oil = Equipment.new("Oil (2 flasks)", "Lamp oil for lanterns and other uses", "Consumable", 2.0, 2)
	equipment.append(oil)
	
	var healingPotion = Equipment.new("Healing Potion", "Restores 25 health when consumed", "Consumable", 0.5, 50)
	healingPotion.special_effects.append("Restores 25 HP")
	equipment.append(healingPotion)
	
	var lockpicks = Equipment.new("Lockpicks", "Set of fine tools for picking locks", "Tool", 0.5, 25)
	lockpicks.special_effects.append("Required for lockpicking")
	equipment.append(lockpicks)
	
	var grappling_hook = Equipment.new("Grappling Hook", "Iron hook attached to rope for climbing", "Tool", 4.0, 15)
	equipment.append(grappling_hook)
	
	var shovel = Equipment.new("Shovel", "Sturdy tool for digging", "Tool", 8.0, 5)
	equipment.append(shovel)
	
	var mirror = Equipment.new("Small Mirror", "Polished steel mirror for signaling and looking around corners", "Tool", 0.5, 5)
	equipment.append(mirror)
	
	var chalk = Equipment.new("Chalk (10 pieces)", "For marking walls and leaving trail markers", "Tool", 0.1, 1)
	equipment.append(chalk)
	
	return equipment

static func get_weapons() -> Array[Equipment]:
	"""Get a list of basic weapons"""
	var weapons = []
	
	var dagger = Equipment.new("Dagger", "Simple, versatile blade", "Weapon", 1.0, 10)
	dagger.stat_modifiers["Strength"] = 1
	weapons.append(dagger)
	
	var sword = Equipment.new("Short Sword", "Balanced one-handed blade", "Weapon", 3.0, 25)
	sword.stat_modifiers["Strength"] = 2
	weapons.append(sword)
	
	var staff = Equipment.new("Quarterstaff", "Sturdy wooden staff", "Weapon", 4.0, 5)
	staff.stat_modifiers["Strength"] = 1
	weapons.append(staff)
	
	var bow = Equipment.new("Short Bow", "Simple ranged weapon", "Weapon", 2.0, 20)
	bow.stat_modifiers["Agility"] = 1
	weapons.append(bow)
	
	var arrows = Equipment.new("Arrows (20)", "Standard arrows for bows", "Consumable", 1.0, 5)
	weapons.append(arrows)
	
	return weapons

static func get_armor() -> Array[Equipment]:
	"""Get a list of basic armor"""
	var armor = []
	
	var leather = Equipment.new("Leather Armor", "Basic protection made from treated hide", "Armor", 10.0, 45)
	leather.stat_modifiers["Fortitude"] = 1
	armor.append(leather)
	
	var shield = Equipment.new("Small Shield", "Wooden shield with metal rim", "Armor", 6.0, 15)
	shield.stat_modifiers["Fortitude"] = 1
	armor.append(shield)
	
	var cloak = Equipment.new("Traveler's Cloak", "Warm cloak for protection from elements", "Armor", 4.0, 5)
	cloak.stat_modifiers["Charisma"] = 1
	armor.append(cloak)
	
	return armor