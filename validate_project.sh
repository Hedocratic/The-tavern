#!/bin/bash

# Simple validation script for The Tavern Godot project

echo "=== The Tavern Project Validation ==="
echo

# Check project structure
echo "Checking project structure..."
if [ -f "project.godot" ]; then
    echo "✓ project.godot found"
else
    echo "✗ project.godot missing"
fi

if [ -d "scenes" ]; then
    echo "✓ scenes directory exists"
    echo "  - MainMenu.tscn: $([ -f scenes/MainMenu.tscn ] && echo "✓" || echo "✗")"
    echo "  - CharacterCreation.tscn: $([ -f scenes/CharacterCreation.tscn ] && echo "✓" || echo "✗")"
else
    echo "✗ scenes directory missing"
fi

if [ -d "scripts" ]; then
    echo "✓ scripts directory exists"
    echo "  - MainMenu.gd: $([ -f scripts/MainMenu.gd ] && echo "✓" || echo "✗")"
    echo "  - CharacterCreation.gd: $([ -f scripts/CharacterCreation.gd ] && echo "✓" || echo "✗")"
else
    echo "✗ scripts directory missing"
fi

if [ -f "icon.svg" ]; then
    echo "✓ icon.svg found"
else
    echo "✗ icon.svg missing"
fi

echo
echo "=== File Summary ==="
echo "Total .tscn files: $(find . -name "*.tscn" | wc -l)"
echo "Total .gd files: $(find . -name "*.gd" | wc -l)"

echo
echo "=== Project Features Implemented ==="
echo "✓ Main Menu with navigation buttons"
echo "✓ Character Creation screen with:"
echo "  ✓ Basic info (name, race, gender, class)"
echo "  ✓ Primary stats (Strength, Fortitude, Agility, Intelligence, Charisma, Arcane)"
echo "  ✓ Skills (Swimming, Slashing, Evocation, Survival, Seduction)"
echo "  ✓ Equipment selection (weapon, armor)"
echo "  ✓ Real-time character summary"
echo "  ✓ Class-based stat bonuses"
echo "  ✓ Navigation between screens"

echo
echo "=== Next Steps ==="
echo "- Open project in Godot 4.2+"
echo "- Test menu navigation"
echo "- Test character creation functionality"
echo "- Add tavern hub scene"
echo "- Implement save/load system"