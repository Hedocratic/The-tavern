# The Tavern - Project Setup

This folder contains the Godot project files for "The Tavern" RPG game based on the Game Design Document in the main README.md.

## Project Structure

```
scenes/
  ├── MainMenu.tscn           # Main menu scene
  └── CharacterCreation.tscn  # Character creation screen

scripts/
  ├── MainMenu.gd             # Main menu logic
  └── CharacterCreation.gd    # Character creation logic

project.godot                 # Godot project configuration
icon.svg                     # Project icon
validate_project.sh          # Project validation script
```

## Features Implemented

### Main Menu
- Title screen with tavern theme
- Navigation buttons (New Game, Load Game, Options, Quit)
- Links to character creation on "New Game"

### Character Creation Screen
Based on the GDD specifications:

**Basic Information:**
- Character name input
- Race selection (Human, Elf, Dwarf, Halfling)
- Gender selection (Male, Female, Non-binary)
- Class selection (Fighter, Rogue, Wizard, Cleric, Ranger, Bard)

**Primary Statistics (as per GDD):**
- Strength (1-20)
- Fortitude (1-20)
- Agility (1-20)
- Intelligence (1-20)
- Charisma (1-20)
- Arcane (1-20)

**Skills:**
- Swimming
- Slashing
- Evocation
- Survival
- Seduction

**Equipment:**
- Weapon selection
- Armor selection

**Features:**
- Real-time character summary with calculated secondary stats
- Class-based stat bonuses
- Navigation back to main menu
- Character data validation

## How to Use

1. **Open in Godot:**
   - Install Godot 4.2 or later
   - Open the project by selecting the `project.godot` file

2. **Test the Game:**
   - Run the project (F5 in Godot)
   - Navigate through the main menu
   - Test character creation functionality

3. **Validate Project:**
   ```bash
   ./validate_project.sh
   ```

## Character Data Model

The character creation implements the data model from the GDD:

```gdscript
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
```

## Next Development Steps

According to the GDD, the next priorities should be:
1. Tavern hub implementation
2. Basic inventory system
3. Save/load functionality
4. Procedural dungeon exploration
5. Grid-based combat system

## Design Notes

- UI uses a tavern-appropriate color scheme (browns and golds)
- All primary stats from the GDD are included
- Class selection affects starting stats as mentioned in the GDD
- Character creation follows the gameplay loop described in the GDD
- Prepared for the turn-based party RPG mechanics outlined in the design document
