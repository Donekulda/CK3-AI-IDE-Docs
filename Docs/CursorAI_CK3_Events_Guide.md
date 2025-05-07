# Crusader Kings 3 Events Guide for Cursor AI

This guide covers the events system in Crusader Kings 3 to help Cursor AI assist with event scripting and storytelling.

## Event Structure and Basics

Events in CK3 are defined in `.txt` files within the `events/` directory and follow this structure:

```
namespace = my_mod_name
my_mod_name.0001 = {
    type = character_event
    title = my_mod_name.0001.t
    desc = my_mod_name.0001.desc
    theme = theme_key
    
    left_portrait = {
        character = root
        animation = personality_honorable
    }
    
    trigger = {
        # Conditions for event to be eligible to fire
    }
    
    immediate = {
        # Effects that happen when event fires, before options
    }
    
    option = {
        name = my_mod_name.0001.a
        # Effects when this option is chosen
    }
    
    option = {
        name = my_mod_name.0001.b
        # Effects for alternate option
    }
}
```

### Event Types
- `character_event` - Standard event popup
- `letter_event` - Event in letter format
- `court_event` - Event in the royal court interface
- `activity_event` - Event during activities like hunts

### Event Fields
- **type**: Determines the event window style
- **title/desc**: Localization keys for text
- **theme**: Visual theme for the event window
- **trigger**: Conditions for event eligibility
- **immediate**: Effects that happen when event fires
- **option**: Choices available to the player
- **after**: Effects executed after the event ends

## Event Portraits and Visuals

### Portrait Blocks
```
left_portrait = {
    character = root
    animation = personality_honorable
}

right_portrait = {
    character = scope:target_character
    animation = worry
}
```

### Available Portrait Positions
- `left_portrait`
- `right_portrait`
- `center_portrait`
- `lower_left_portrait`
- `lower_center_portrait`
- `lower_right_portrait`

### Animations
Common animations include:
- `personality_bold`
- `personality_honorable`
- `personality_rational`
- `worry`
- `anger`
- `grief`
- `happiness`
- `disgust`

### Event Themes
```
theme = {
    background = "stone_backdrop"
    icon = "hunting"
}
```

Common themes:
- `councillor`
- `intrigue`
- `diplomacy`
- `religion`
- `martial`
- `wilderness`

## Event Storytelling and Chains

### Creating Event Storylines
Event storylines connect multiple events into a narrative sequence:

1. **Planning**
   - Map out character arcs, decision points, and outcomes
   - Identify key trigger conditions (traits, positions, resources)
   - Create flowcharts for complex storylines

2. **Event Numbering System**
   - Use consistent numbering for organization
   - Example: `my_mod.1000` through `my_mod.1099` for one storyline
   - Reserve blocks of 10-100 IDs per storyline

3. **Chaining Events**
```
# First event
my_mod.1000 = {
    # ...
    option = {
        name = my_mod.1000.a
        trigger_event = {
            id = my_mod.1001 # Next event in chain
            days = 7 # Delay before next event
        }
    }
}

# Second event
my_mod.1001 = {
    trigger = {
        has_character_flag = started_storyline_xyz
    }
    # ...
}
```

### Event Cycles and Loops

#### Cycles
Events that repeat at intervals or under specific conditions:

```
my_mod.2000 = {
    # ...
    immediate = {
        if = {
            limit = { has_character_flag = cycle_stage_1 }
            remove_character_flag = cycle_stage_1
            add_character_flag = cycle_stage_2
        }
        else_if = {
            limit = { has_character_flag = cycle_stage_2 }
            remove_character_flag = cycle_stage_2
            add_character_flag = cycle_stage_3
        }
        else {
            add_character_flag = cycle_stage_1
        }
    }
    
    after = {
        trigger_event = {
            id = my_mod.2000
            days = 365 # Repeat yearly
        }
    }
}
```

#### Loops
Events that can feed back into themselves:

```
# Start loop
my_mod.3000 = {
    # ...
    option = {
        name = my_mod.3000.continue
        trigger_event = {
            id = my_mod.3001 # Continue loop
        }
    }
    option = {
        name = my_mod.3000.exit
        # Exit loop effects
    }
}

# Loop continues
my_mod.3001 = {
    # ...
    option = {
        # Option that can lead back to the start
        trigger_event = { id = my_mod.3000 }
    }
}
```

## Tracking Event Progress

### Character Flags
Use flags to track story progress:
```
# Set flag
add_character_flag = quest_started

# Check flag in later events
trigger = {
    has_character_flag = quest_started
}

# Remove flag when done
remove_character_flag = quest_started
```

### Timed Character Flags
Automatically expire after a period:
```
add_character_flag = {
    flag = recent_event
    days = 365 # Expires after a year
}
```

### Variables
For numerical progression:
```
# Set initial value
set_variable = {
    name = story_stage
    value = 0
}

# Increment in each event
change_variable = {
    name = story_stage
    add = 1
}

# Check progress
trigger = {
    has_variable = story_stage
    var:story_stage >= 3
}
```

### Scope Saving
Save important characters and objects:
```
# Save character for later reference
save_scope_as = quest_target

# Reference in later events
scope:quest_target = {
    add_prestige = 100
}
```

## Conditional Branching and Merging

### Branching Events
Create different paths based on character traits or choices:

```
my_mod.4000 = {
    # ...
    option = {
        name = my_mod.4000.brave
        trigger = { has_trait = brave }
        trigger_event = { id = my_mod.4001 } # Brave path
    }
    option = {
        name = my_mod.4000.diplomatic
        trigger = { has_trait = gregarious }
        trigger_event = { id = my_mod.4002 } # Diplomatic path
    }
    option = {
        name = my_mod.4000.default
        trigger_event = { id = my_mod.4003 } # Default path
    }
}
```

### Merging Paths
Return from different branches to a common event:

```
# Events 4001, 4002, and 4003 all lead back to 4004
my_mod.4001 = {
    # ...
    option = {
        add_character_flag = took_brave_path
        trigger_event = { id = my_mod.4004 }
    }
}

my_mod.4004 = {
    # ...
    immediate = {
        if = {
            limit = { has_character_flag = took_brave_path }
            # Special effects for brave path
        }
        else_if = {
            limit = { has_character_flag = took_diplomatic_path }
            # Special effects for diplomatic path
        }
    }
}
```

## Event Widgets and Custom UI

Create interactive elements in events:
```
my_mod.5000 = {
    # ...
    widget = {
        gui = "event_widget_artifact"
        container = "custom_widget"
        visible = {
            exists = scope:artifact
        }
    }
}
```

### Common Widgets
- `event_widget_artifact`
- `event_widget_character_name`
- `event_widget_stress`
- `event_widget_warning`
- `event_widget_scheme`
- `event_widget_event_chain_progress`

## On-Action Integration

Trigger events from game actions:
```
# In common/on_action/my_mod_on_actions.txt
on_character_marriage = {
    events = {
        my_mod.6000 # Always triggers on marriage
    }
    random_events = {
        chance_to_fire = {
            value = 0.3 # 30% chance
        }
        events = {
            my_mod.6001
            my_mod.6002
        }
    }
}
```

### Important On-Actions
- `on_birth`
- `on_character_death`
- `on_marriage`
- `on_battle_won`
- `on_war_won`
- `on_war_lost`
- `on_realm_created`
- `on_yearly_pulse`
- `on_five_year_pulse`

## Event Cooldowns and Random Weight

### Cooldowns
Prevent event spam:
```
my_mod.7000 = {
    # ...
    cooldown = {
        days = 180 # Six-month cooldown
    }
}
```

### Random Weight
Control chance of an event firing within random event lists:
```
random_events = {
    100 = my_mod.8000 # Higher weight, more likely
    50 = my_mod.8001
    25 = my_mod.8002 # Lower weight, less likely
}
```

## Localization for Events

Events require proper localization entries:
```
# In localization/english/my_mod_events_l_english.yml
l_english:
 my_mod.0001.t:0 "The Discovery"
 my_mod.0001.desc:0 "Your advisors have uncovered an ancient text that speaks of a powerful artifact hidden in the mountains of [location.GetName]."
 my_mod.0001.a:0 "We must find it!"
 my_mod.0001.b:0 "This is a waste of time."
```

### Dynamic Text
Use dynamic references:
```
my_mod.0002.desc:0 "The [ROOT.GetCharacter.GetFaith.GetName] clergy are outraged by your actions!"
```

## Testing and Debugging Events

### Debug Mode
Enable debug mode in the game to test events more easily:
```
debug_mode
event my_mod.0001 # Fire specific event
```

### Log Messages
Add log entries to track execution:
```
immediate = {
    log = "Event my_mod.0001 fired for [ROOT.GetCharacter.GetName]"
}
```

## Best Practices

1. **Modular Design**
   - Create reusable event patterns
   - Split complex storylines into smaller event chains

2. **Performance**
   - Avoid excessive checks in frequently triggered events
   - Use targeted character selection instead of iterating all characters

3. **Balanced Storytelling**
   - Mix short-term and long-term consequences
   - Include both beneficial and challenging outcomes
   - Provide meaningful choices with tradeoffs

4. **Localization Integration**
   - Create localization keys for all text elements
   - Use dynamic text with ROOT/FROM references
   - Support gender variations with GetWomanMan constructs

5. **Quality Control**
   - Test with different character types
   - Verify all branches of event chains
   - Check for spelling and grammar in localization

## Example: Complete Event Storyline

```
namespace = artifact_quest

# Initial quest event
artifact_quest.1 = {
    type = character_event
    title = artifact_quest.1.t
    desc = artifact_quest.1.desc
    theme = rumor
    
    trigger = {
        is_ruler = yes
        learning >= 8
        NOT = { has_character_flag = artifact_quest_active }
    }
    
    immediate = {
        random_courtier = {
            limit = {
                is_adult = yes
                opinion = { target = root value > 0 }
            }
            save_scope_as = artifact_informant
        }
    }
    
    left_portrait = {
        character = root
    }
    
    right_portrait = {
        character = scope:artifact_informant
    }
    
    option = {
        name = artifact_quest.1.accept
        add_character_flag = artifact_quest_active
        trigger_event = { id = artifact_quest.2 days = 5 }
    }
    
    option = {
        name = artifact_quest.1.decline
    }
}

# Quest continues with challenge
artifact_quest.2 = {
    type = character_event
    title = artifact_quest.2.t
    desc = artifact_quest.2.desc
    theme = intrigue
    
    trigger = {
        has_character_flag = artifact_quest_active
    }
    
    # More event content...
}

# Outcome events follow...
```

## Reference Documentation

For more detailed information, consult:
- `on_actions_detailed.json` - Complete list of game triggers
- `effects_detailed.json` - Available actions in event options
- `triggers_detailed.json` - Available conditions for event triggers
- `event_targets_detailed.json` - Special event targets and scopes 