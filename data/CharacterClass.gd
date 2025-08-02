class_name CharacterClass
extends Resource

@export var name: String
@export var description: String
@export var starting_stats: Dictionary = {}
@export var starting_skills: Dictionary = {}
@export var starting_gold: int = 100

static func get_all_classes() -> Array:
	var classes = []
	
	# Warrior
	var warrior = CharacterClass.new()
	warrior.name = "Warrior"
	warrior.description = "Melee tank and single target damage dealer."
	warrior.starting_stats = {
		"Strength": 16, "Fortitude": 15, "Agility": 12, 
		"Intelligence": 8, "Charisma": 10, "Arcane": 6
	}
	warrior.starting_skills = {
		"Slashing Weapons": 3, "Heavy Armor": 2, "Shields": 2
	}
	warrior.starting_gold = 150
	classes.append(warrior)
	
	# Thief
	var thief = CharacterClass.new()
	thief.name = "Thief"
	thief.description = "Agile, stealthy, excels at pickpocketing and lockpicking"
	thief.starting_stats = {
		"Strength": 10, "Fortitude": 12, "Agility": 16, 
		"Intelligence": 14, "Charisma": 11, "Arcane": 7
	}
	thief.starting_skills = {
		"Stealth": 3, "Pickpocketing": 3, "Lockpicking": 2
	}
	thief.starting_gold = 120
	classes.append(thief)
	
	# Assassin
	var assassin = CharacterClass.new()
	assassin.name = "Assassin"
	assassin.description = "Agile, stealthy, excels at backstabs and poisons"
	assassin.starting_stats = {
		"Strength": 12, "Fortitude": 11, "Agility": 16, 
		"Intelligence": 13, "Charisma": 9, "Arcane": 9
	}
	assassin.starting_skills = {
		"Stealth": 3, "Backstab": 3, "Poison Crafting": 2
	}
	assassin.starting_gold = 130
	classes.append(assassin)
	
	# Wizard
	var wizard = CharacterClass.new()
	wizard.name = "Wizard"
	wizard.description = "Versatile spellcaster who can learn any spell, but is vulnerable"
	wizard.starting_stats = {
		"Strength": 6, "Fortitude": 8, "Agility": 10, 
		"Intelligence": 16, "Charisma": 12, "Arcane": 18
	}
	wizard.starting_skills = {
		"Evocation": 3, "Arcane Knowledge": 3, "Alchemy": 2
	}
	wizard.starting_gold = 100
	classes.append(wizard)
	
	# Cleric
	var cleric = CharacterClass.new()
	cleric.name = "Cleric"
	cleric.description = "Healer, buffer, minor melee."
	cleric.starting_stats = {
		"Strength": 12, "Fortitude": 14, "Agility": 9, 
		"Intelligence": 14, "Charisma": 16, "Arcane": 15
	}
	cleric.starting_skills = {
		"Restoration": 3, "Enchantment": 2, "Blunt Weapons": 2
	}
	cleric.starting_gold = 110
	classes.append(cleric)
	
	# Paladin
	var paladin = CharacterClass.new()
	paladin.name = "Paladin"
	paladin.description = "Hybrid tank/healer, holy powers."
	paladin.starting_stats = {
		"Strength": 14, "Fortitude": 16, "Agility": 10, 
		"Intelligence": 11, "Charisma": 15, "Arcane": 14
	}
	paladin.starting_skills = {
		"Slashing Weapons": 2, "Heavy Armor": 2, "Restoration": 2
	}
	paladin.starting_gold = 140
	classes.append(paladin)
	
	# Barbarian
	var barbarian = CharacterClass.new()
	barbarian.name = "Barbarian"
	barbarian.description = "High strength, rage, survivability."
	barbarian.starting_stats = {
		"Strength": 18, "Fortitude": 17, "Agility": 13, 
		"Intelligence": 6, "Charisma": 8, "Arcane": 4
	}
	barbarian.starting_skills = {
		"Slashing Weapons": 3, "Survival": 2, "Intimidation": 2
	}
	barbarian.starting_gold = 80
	classes.append(barbarian)
	
	# Druid
	var druid = CharacterClass.new()
	druid.name = "Druid"
	druid.description = "Nature magic, shapeshifting, animal handling."
	druid.starting_stats = {
		"Strength": 11, "Fortitude": 13, "Agility": 14, 
		"Intelligence": 15, "Charisma": 12, "Arcane": 15
	}
	druid.starting_skills = {
		"Animal Handling": 3, "Survival": 3, "Herbalism": 2
	}
	druid.starting_gold = 90
	classes.append(druid)
	
	# Necromancer
	var necromancer = CharacterClass.new()
	necromancer.name = "Necromancer"
	necromancer.description = "Summoning, curses, debuffs."
	necromancer.starting_stats = {
		"Strength": 7, "Fortitude": 10, "Agility": 11, 
		"Intelligence": 16, "Charisma": 9, "Arcane": 17
	}
	necromancer.starting_skills = {
		"Necromancy": 3, "Summoning": 3, "Arcane Knowledge": 2
	}
	necromancer.starting_gold = 95
	classes.append(necromancer)
	
	# Monk
	var monk = CharacterClass.new()
	monk.name = "Monk"
	monk.description = "Martial arts, speed, self-buffs."
	monk.starting_stats = {
		"Strength": 13, "Fortitude": 14, "Agility": 16, 
		"Intelligence": 12, "Charisma": 13, "Arcane": 12
	}
	monk.starting_skills = {
		"Unarmed Combat": 3, "Dodge": 3, "Enchantment": 2
	}
	monk.starting_gold = 70
	classes.append(monk)
	
	# Warlock
	var warlock = CharacterClass.new()
	warlock.name = "Warlock"
	warlock.description = "Wild, innate magic, unpredictable powers."
	warlock.starting_stats = {
		"Strength": 9, "Fortitude": 11, "Agility": 12, 
		"Intelligence": 13, "Charisma": 15, "Arcane": 20
	}
	warlock.starting_skills = {
		"Evocation": 2, "Illusion": 2, "Arcane Knowledge": 3
	}
	warlock.starting_gold = 85
	classes.append(warlock)
	
	return classes