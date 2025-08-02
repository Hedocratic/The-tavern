class_name Character
extends Resource

@export var name: String = ""
@export var character_class: String = ""
@export var race: String = "Human"
@export var gender: String = "Male"
@export var level: int = 1
@export var experience: int = 0

# Primary Stats
@export var primary_stats: Dictionary = {
	"Strength": 10,
	"Fortitude": 10,
	"Agility": 10,
	"Intelligence": 10,
	"Charisma": 10,
	"Arcane": 10
}

# Secondary Stats (derived from primary stats or equipment)
@export var secondary_stats: Dictionary = {}

# Skills
@export var skills: Dictionary = {}

@export var inventory: Array = []
@export var equipped_items: Dictionary = {}
@export var status_effects: Array = []
@export var buffs: Array = []
@export var health: int = 100
@export var max_health: int = 100
@export var mana: int = 50
@export var max_mana: int = 50
@export var gold: int = 100

func _init():
	_initialize_skills()
	_calculate_secondary_stats()

func _initialize_skills():
	# Combat Skills
	var combat_skills = [
		"Slashing Weapons", "Blunt Weapons", "Piercing Weapons", 
		"Archery", "Throwing Weapons", "Shields", "Dual Wielding", 
		"Unarmed Combat", "Heavy Armor", "Light Armor", "Dodge"
	]
	
	# Magic Skills
	var magic_skills = [
		"Evocation", "Restoration", "Illusion", "Enchantment", 
		"Necromancy", "Arcane Knowledge", "Alchemy", "Ritual Magic", "Summoning"
	]
	
	# Stealth & Subterfuge Skills
	var stealth_skills = [
		"Stealth", "Pickpocketing", "Lockpicking", "Trap Setting", 
		"Trap Disarming", "Poison Crafting", "Backstab"
	]
	
	# Social Skills
	var social_skills = [
		"Persuasion", "Intimidation", "Seduction", "Deception", 
		"Performance", "Bartering"
	]
	
	# Survival & Utility Skills
	var survival_skills = [
		"Survival", "Tracking", "Animal Handling", "First Aid", 
		"Swimming", "Climbing", "Fishing", "Cooking", "Navigation", 
		"Memory", "Crafting", "Blacksmithing", "Brewing", "Herbalism"
	]
	
	# Other / Special Skills
	var special_skills = [
		"Leadership", "Morale Boosting", "Inspiration", "Disguise", 
		"Lore", "Investigation"
	]
	
	# Initialize all skills to 0
	var all_skills = combat_skills + magic_skills + stealth_skills + social_skills + survival_skills + special_skills
	for skill in all_skills:
		if not skills.has(skill):
			skills[skill] = 0

func _calculate_secondary_stats():
	# Health Points (HP) - based on Fortitude
	max_health = 80 + (primary_stats.get("Fortitude", 10) * 5)
	
	# Mana/Energy Points (MP/EP) - based on Intelligence and Arcane
	max_mana = 30 + (primary_stats.get("Intelligence", 10) * 2) + (primary_stats.get("Arcane", 10) * 3)
	
	# Speed (affects turn order) - based on Agility
	secondary_stats["Speed"] = 10 + primary_stats.get("Agility", 10)
	
	# Carry Capacity - based on Strength
	secondary_stats["Carry Capacity"] = 20 + (primary_stats.get("Strength", 10) * 3)
	
	# Dodge/Evasion - based on Agility
	secondary_stats["Dodge"] = primary_stats.get("Agility", 10) / 2
	
	# Accuracy - based on Agility and Intelligence
	secondary_stats["Accuracy"] = 50 + (primary_stats.get("Agility", 10) * 2) + primary_stats.get("Intelligence", 10)
	
	# Critical Chance - based on Agility
	secondary_stats["Critical Chance"] = primary_stats.get("Agility", 10) / 4
	
	# Critical Resistance - based on Fortitude
	secondary_stats["Critical Resistance"] = primary_stats.get("Fortitude", 10) / 3
	
	# Armor Rating - base value, modified by equipment
	secondary_stats["Armor Rating"] = 5 + primary_stats.get("Fortitude", 10) / 2
	
	# Magic Resistance - based on Arcane and Intelligence
	secondary_stats["Magic Resistance"] = (primary_stats.get("Arcane", 10) + primary_stats.get("Intelligence", 10)) / 3
	
	# Perception - based on Intelligence and Charisma
	secondary_stats["Perception"] = (primary_stats.get("Intelligence", 10) + primary_stats.get("Charisma", 10)) / 2
	
	# Stealth - based on Agility and skill
	secondary_stats["Stealth"] = primary_stats.get("Agility", 10) + skills.get("Stealth", 0) * 5
	
	# Persuasion - based on Charisma and skill
	secondary_stats["Persuasion"] = primary_stats.get("Charisma", 10) + skills.get("Persuasion", 0) * 5
	
	# Regeneration - based on Fortitude
	secondary_stats["HP Regeneration"] = primary_stats.get("Fortitude", 10) / 5
	secondary_stats["MP Regeneration"] = primary_stats.get("Arcane", 10) / 4
	
	# Block/Parry Chance - base value, modified by skills and equipment
	secondary_stats["Block Chance"] = skills.get("Shields", 0) * 3
	secondary_stats["Parry Chance"] = (skills.get("Slashing Weapons", 0) + skills.get("Piercing Weapons", 0)) / 2
	
	# Spell Power - based on Arcane and Intelligence
	secondary_stats["Spell Power"] = primary_stats.get("Arcane", 10) + (primary_stats.get("Intelligence", 10) / 2)
	
	# Healing Power - based on Arcane and Charisma
	secondary_stats["Healing Power"] = primary_stats.get("Arcane", 10) + (primary_stats.get("Charisma", 10) / 2)
	
	# Movement Range - based on Agility
	secondary_stats["Movement Range"] = 3 + (primary_stats.get("Agility", 10) / 5)
	
	# Morale - base value, affected by events
	secondary_stats["Morale"] = 50 + primary_stats.get("Charisma", 10)
	
	# Stamina - based on Fortitude and Agility
	secondary_stats["Stamina"] = 10 + (primary_stats.get("Fortitude", 10) + primary_stats.get("Agility", 10)) / 2

func apply_class_bonuses(character_class_data: CharacterClass):
	character_class = character_class_data.name
	
	# Apply starting stats
	for stat in character_class_data.starting_stats:
		primary_stats[stat] = character_class_data.starting_stats[stat]
	
	# Apply starting skills
	for skill in character_class_data.starting_skills:
		skills[skill] = character_class_data.starting_skills[skill]
	
	# Apply starting gold
	gold = character_class_data.starting_gold
	
	# Recalculate secondary stats
	_calculate_secondary_stats()
	
	# Set health and mana to max
	health = max_health
	mana = max_mana