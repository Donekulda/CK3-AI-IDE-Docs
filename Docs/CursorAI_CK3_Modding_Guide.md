# Crusader Kings 3 Modding Guide for Cursor AI

This documentation provides essential knowledge about Crusader Kings 3 (CK3) modding to help Cursor AI assist with mod development.

## File Structure and Naming Conventions

### Directory Organization
CK3 uses a modular folder structure with specific purposes:
- **common/** - Core game rules, definitions, and mechanics
- **events/** - Event definitions and event chains
- **gfx/** - Graphical assets (textures, icons, models)
- **gui/** - User interface definitions
- **history/** - Historical data (characters, provinces, titles)
- **localization/** - In-game text for all languages

### File Naming
Files should follow this pattern: `PREFIX_NUMBER_descriptive_name.txt`
- **PREFIX**: 2-5 letters unique to your mod (e.g., first letters of mod name)
- **NUMBER**: Controls load order (lower numbers load first)
- **Example**: `WW_00_forge_staff_decision.txt`

## Key Game Systems

### Triggers and Effects
- **Triggers**: Boolean conditions that return true/false
- **Effects**: Functions that make changes to the game state
- **Location**: `common/scripted_triggers/` and `common/scripted_effects/`

### Events System
Events have this basic structure:
```
namespace = example_namespace
example_event_id = {
    type = character_event
    title = example_event.title
    desc = example_event.desc
    theme = example_theme
    
    trigger = { ... }
    immediate = { ... }
    option = { ... }
}
```

Event properties include:
- **type**: character_event, letter_event, court_event, activity_event
- **portraits**: Define characters shown in event windows
- **widgets**: Custom UI elements for events

### Scripted Values and Modifiers
- **script_values/**: Dynamically calculated values that adjust based on game state
- **scripted_modifiers/**: Dynamic modifiers for events and AI interactions

### On-Actions
Events triggered by specific game actions (births, deaths, wars starting, etc.)

## Common Directories and Their Contents

### Character Systems
- **character_backgrounds/** - Background traits and history
- **character_interactions/** - How characters interact with each other
- **traits/** - Character traits affecting attributes and behavior

### Government and Politics
- **governments/** - Types of governments
- **laws/** - Legal systems and rules
- **council_positions/** - Realm council mechanics
- **decisions/** - Action choices for players

### Culture and Religion
- **culture/** - Cultural mechanics and innovations
- **religion/** - Religious doctrines and mechanics

### Military Systems
- **men_at_arms_types/** - Troop unit definitions
- **casus_belli_types/** - War justification types

## Modding Best Practices

1. **Avoid Direct Overwrites**: Create unique files rather than overwriting base game files
2. **Test Thoroughly**: Check for compatibility issues and bugs
3. **Use Script Values**: For dynamic calculations that need to change during gameplay
4. **Proper Localization**: Always add localization entries for new content
5. **Follow Game Conventions**: Match the style of existing code

## Working with Game Concepts and Localization

### Game Concepts
Define new concepts in `common/game_concepts/` to create in-game tooltips and wiki entries.

### Localization
- Store in `localization/` directory with language code (e.g., `english/`)
- Use format: `KEY:0 "Text"` with proper encoding
- Support dynamic text with first-person/second-person switching
- Reference other localization with `$key$`

## Tools for Development

- **Error Log**: Check for bugs and issues
- **Debug Mode**: Test features and trigger events
- **Console Commands**: Manipulate game state for testing

## Example: Adding a New Trait

1. Create `PREFIX_NUMBER_traits.txt` in `common/traits/`
2. Define trait properties, triggers, and effects
3. Add an icon to `gfx/interface/traits/`
4. Add localization in `localization/english/traits_l_english.yml`
5. (Optional) Create events that use or give the trait

## Event Documentation

Events are key storytelling and gameplay mechanisms. They require:
- Unique namespace and ID
- Title and description with localization keys
- Trigger conditions determining when they can fire
- Effect blocks that execute when the event fires
- Option choices for the player with consequences

## Further Resources

- Paradox Wiki: Comprehensive documentation on mechanics
- Paradox Forums: Community discussions and tutorials
- On-Action List: Complete list of game triggers in `on_actions_detailed.json`
- Triggers List: Available conditions in `triggers_detailed.json`
- Effects List: Available actions in `effects_detailed.json` 