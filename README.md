# The Tavern: Game Design Document (GDD) / Product Requirements Document (PRD)

## 1. Game Overview

**Title:** The Tavern  
**Genre:** Turn-based, party-based RPG with grid-based combat and map-based exploration  
**Engine:** Godot  
**Core Pillars:**  
- Deep character customization  
- Rich stats and conditions system ("tiny moving parts")  
- Procedural dungeon exploration  
- Strategic, turn-based combat  
- Social hub (the Tavern) as the home base

---

## 2. Vision Statement

*"The Tavern" is a party-based RPG where players guide a team of custom characters through dangerous, procedurally-generated dungeons, returning to a bustling tavern between adventures. With intricate stats, skills, and equipment systems, every choice matters and every adventure is unique.*

---

## 3. Key Features

- **Detailed Character Creation:** Choose class, allocate stats and skill points, buy equipment, customize appearance and name.
- **Tavern Hub:** Upgrade, recruit, barter, and heal. Multiple interactive rooms (Merchant, Bar, Blacksmith, etc.).
- **Procedural Dungeon Exploration:** Fog-of-war map, text-based and interactive challenges, evolving dungeon layout.
- **Turn-Based Grid Combat:** Speed-based initiative, tactical abilities per class, persistent status effects and buffs.
- **Stats & Skills System:**  
  - **Primary Stats:** Strength, Fortitude, Agility, Intelligence, Charisma, Arcane
  - **Secondary Stats:** Derived (e.g., Speed, Carry Capacity)
  - **Skills:** Wide variety, each tied to primary stats (e.g., Swimming, Seduction, Slashing, Evocation, Survival)
- **Rich Item System:** Weight, buffs, unique effects. Carry capacity based on character stats.
- **Persistent Effects:** Status effects, buffs, inventory, experience, and more are tracked per character.
- **Procedural Content:** Dungeons and their layouts change each playthrough.

---

## 4. Gameplay Loop

1. **Character Creation**
    - Pick class (affects starting stats, skills, gold)
    - Allocate stat and skill points
    - Purchase equipment
    - Customize appearance, gender, race, and name

2. **Tavern Phase**
    - Upgrade/fix equipment (Blacksmith)
    - Barter/trade (Merchant)
    - Recruit/heal (Bar, Healer)
    - Prepare for adventure (manage party, inventory, quests)
    - Initiate adventure via portal

3. **Exploration Phase**
    - Party enters procedural dungeon
    - Explore rooms (map with fog of war)
    - Encounter events, text prompts, puzzles, and combat

4. **Combat Phase**
    - Switch to grid-based tactical combat
    - Turn order by Speed stat
    - Use abilities, items, and tactics to defeat enemies

5. **Return/Exit**
    - Find exit portal to return to Tavern
    - Heal, upgrade, recruit, repeat loop

---

## 5. Core Systems

### 5.1 Character System

- **Attributes:**  
  - Primary: Strength, Fortitude, Agility, Intelligence, Charisma, Arcane
  - Secondary: Speed, Carry Capacity, etc. (derived from primary)
- **Skills:** Each skill is tied to one or more primary stats and improves with use or experience points.
- **Inventory:**  
  - Items have weight; characters have maximum carry capacity.
  - Equipment affects stats and abilities.
- **Status Effects & Buffs:**  
  - Persistent and dynamic (e.g., poison, morale, fatigue)
- **Progression:**  
  - Level, XP, skill improvement, new abilities unlocked per class

#### Example Character Data Model (Godot/GDScript pseudocode)
```gdscript
class Character:
    var name
    var class
    var race
    var gender
    var level
    var experience
    var stats = {"Strength": 0, "Fortitude": 0, ...}
    var secondary_stats = {"Speed": 0, "CarryCapacity": 0, ...}
    var skills = {"Swimming": 0, "Slashing": 0, ...}
    var inventory = []
    var status_effects = []
    var buffs = []
    var health
    var gold
```

### 5.2 Tavern System

- **Rooms:** Merchant, Bar, Blacksmith, Recruiter, Healer, Portal Chamber
- **Interactions:** Menus for upgrading, shopping, recruiting, healing, and launching adventures

### 5.3 Exploration System

- **Procedural Map:** Randomly generated with fog of war; remembers explored layout
- **Room Events:** Text prompts, dialogues, puzzles, traps, loot, combat triggers

### 5.4 Combat System

- **Grid-Based:** Tactical grid, turn order by Speed
- **Actions:** Movement, attack, ability use, item use, flee
- **Classes:** Unique abilities (e.g., Fireball, Backstab)
- **Enemy AI:** Basic tactics, conditions, targeting logic
- **Resolution:** Combat ends on victory, defeat, or escape

### 5.5 Item System

- **Attributes:** Name, type, stat modifiers, weight, special effects
- **Inventory Management:** Drag/drop, equip/unequip, carry limit enforcement
- **Loot:** Random drops, treasure chests, merchant purchases

---

## 6. Saving & Persistence

- **Data to Save:**  
  - All character data (stats, skills, inventory, status, XP)
  - Tavern state (recruited members, upgrades, gold)
  - Current dungeon state (if mid-adventure)
  - Settings and preferences
- **Format:** JSON or Godot’s built-in resource format
- **Approach:**  
  - On key events (enter/exit tavern, end of combat, explicit save)
  - Autosave checkpoints (optional)

---

## 7. User Experience & Engagement

- **Smooth Menus:** Intuitive, keyboard/mouse friendly, quick transitions between Tavern, map, and combat
- **Feedback:** Animations, visual/audio cues for key actions (stat changes, combat results, skill checks)
- **Procedural Variety:** Ensure randomness feels fair and exciting, not punishing
- **Depth of Choices:** Every stat, skill, item, and decision should matter, allowing creative solutions and unique playstyles
- **Accessibility:** Colorblind-friendly palettes, readable fonts, toggleable text speed

---

## 8. Open Design Questions

- What is the optimal party size for balance and fun?
- How much randomness vs. player agency in procedural generation?
- How to make every stat and skill valuable in a variety of situations?
- How to present information clearly without overwhelming the player?

---

## 9. Next Steps & Prototyping

- Prototype character creation menu (focus: class, stats, skills, equipment, appearance)
- Build basic tavern menu navigation
- Implement simple procedural map with fog of war
- Prototype grid combat with two classes and basic enemies
- Define data structures for characters, inventory, and status effects

---

## 10. References & Inspirations

- Darkest Dungeon (party/tavern loop)
- Divinity: Original Sin (stat/skill depth, grid combat)
- Slay the Spire (procedural map, events)
- Dungeons & Dragons (rich stats/skills system)

---

# Appendix: Answers to Key Design Questions

### What is the game?
A turn-based party RPG with deep customization, grid combat, and procedural dungeon exploration, centered on a social hub (the Tavern).

### How does the game function?
Players create and manage a party, explore dungeons, fight tactical battles, and return to the Tavern to upgrade and recruit. The game tracks a rich array of stats, skills, and effects, influencing every action and event.

### How do I play the game?
1. Create your character(s) with stats, skills, equipment, and appearance
2. Prepare in the Tavern (upgrade, recruit, heal, buy/sell)
3. Venture into procedural dungeons, face events and combat
4. Defeat enemies, overcome challenges, collect loot
5. Return to the Tavern, upgrade and repeat

### How do we save all the information about all the characters?
Use structured data (e.g., JSON) to serialize all relevant character and party info: stats, skills, equipment, status effects, XP, appearance, etc. Save on key events and allow for manual/auto saves.

### How do I make the gameplay smooth and engaging?
- Design intuitive, quick menus and transitions
- Provide clear, satisfying feedback for player actions
- Ensure depth and variety in stats/skills so every decision impacts gameplay
- Balance procedural and handcrafted content for variety and fairness
- Encourage experimentation with party composition and tactics

---

*This document is a living reference; update it as your vision evolves and as you prototype in Godot!*
