# Crusader Kings 3 Scripting Guide for Cursor AI

This guide covers scripting elements, effects, and triggers in Crusader Kings 3 modding to help Cursor AI assist with script development.

## Scripting System Overview

CK3 uses a custom scripting language that powers events, decisions, and game mechanics. Key concepts include:

- **Scopes**: Contexts for script execution (character, title, province, etc.)
- **Effects**: Actions that change game state
- **Triggers**: Conditions that check if something is true
- **Script Values**: Dynamic calculations that change during gameplay
- **Event Targets**: Named references to game objects

## Scripts Location

Scripts are located in several directories:
- **common/scripted_effects/** - Reusable effect blocks
- **common/scripted_triggers/** - Reusable condition blocks
- **common/scripted_modifiers/** - Dynamic modifier calculations
- **common/script_values/** - Custom formulas for game values
- **common/on_action/** - Event hooks for game state changes

## Scopes and Scope Switching

### Main Scopes
- `character` - Individual character
- `title` - Landed title (kingdom, duchy, etc.)
- `province` - Map province
- `culture` - Cultural group
- `faith` - Religious faith
- `dynasty` - Family dynasty

### Scope Operators
- `scope:name` - Reference a previously saved scope
- `root` - The initial scope when the script started
- `this` - The current scope
- `from` - The previous scope before switching
- `fromfrom` - Two scopes back

### Scope Transitions
```
character:12345 = { # In character scope
    realm = { # Now in realm scope
        capital_county = { # Now in title scope
            holder = { # Back to character scope
                # Script here
            }
        }
    }
}
```

### Saving Scopes
```
# Save a permanent scope
save_scope_as = named_scope

# Save a temporary scope (lasts for current script execution)
save_temporary_scope_as = temp_scope

# Reference saved scope
scope:named_scope = {
    # Do something with this scope
}
```

## Effects

Effects are actions that change game state. They are used in event options, decisions, and scripted effects.

### Common Effects

#### Character Effects
```
add_trait = brave
remove_trait = craven
add_gold = 100
add_prestige = 50
add_piety = 25
add_stress = 10
change_culture = culture:swedish
change_faith = faith:catholic
add_character_flag = flag_name
```

#### Title Effects
```
gain_title = title:k_england
destroy_title = title:k_england
create_title = {
    title = title:d_custom
    holder = root
}
change_development_level = 2
```

#### Relationship Effects
```
add_opinion = {
    target = scope:other_character
    modifier = friend_opinion
    opinion = 10
}
set_relation_friend = scope:other_character
start_war = {
    casus_belli = cb_conquest
    target = scope:enemy_realm
}
```

#### Event Effects
```
trigger_event = {
    id = my_event.1
    days = 10
}
send_interface_message = {
    type = event_notification
    title = my_text.title
    desc = my_text.desc
}
```

## Triggers

Triggers are conditions that check if something is true. They return true or false and are used in event conditions, option availability, and other checks.

### Common Triggers

#### Character Triggers
```
is_alive = yes
age >= 16
has_trait = brave
culture = culture:norse
faith = faith:catholic
is_ruler = yes
is_at_war = no
has_character_flag = flag_name
is_imprisoned = no
```

#### Title Triggers
```
has_title = title:k_england
is_de_jure_title = title:e_britannia
tier = kingdom
title_held_since > 10
county = {
    development_level > 10
}
```

#### Relationship Triggers
```
has_relation_friend = scope:other_character
opinion = {
    target = scope:other_character
    value > 50
}
has_truce = scope:other_character
```

#### Resource Triggers
```
gold > 100
prestige > 50
piety > 25
stress < 10
domain_size <= domain_limit
```

### Boolean Operators
```
AND = {
    is_adult = yes
    is_ruler = yes
}

OR = {
    has_trait = brave
    has_trait = zealous
}

NOT = {
    has_trait = craven
}

NOR = { # None of these are true
    has_trait = craven
    has_trait = lazy
}

NAND = { # Not all are true
    has_trait = brave
    has_trait = craven
}
```

### List Triggers
```
any_vassal = {
    count = 2
    is_powerful_vassal = yes
    has_trait = ambitious
}

every_child = {
    limit = {
        is_adult = yes
    }
    add_prestige = 50
}

random_courtier = {
    weight = {
        base = 1
        modifier = {
            add = 5
            has_trait = genius
        }
    }
    add_trait = court_physician
}
```

## Script Values

Script values are dynamic calculations used in various game contexts:

```
my_value = {
    value = 10
    add = {
        value = 5
        if = {
            limit = { has_trait = brave }
            add = 5
        }
    }
    multiply = {
        value = 1.5
        if = {
            limit = { is_ruler = yes }
            add = 0.5
        }
    }
    min = 0
    max = 100
}
```

## On Actions

On actions define when events trigger based on game state changes:

```
on_birth = {
    events = {
        birth_events.0001 # Fires for every birth
    }
    random_events = {
        chance_to_fire = {
            value = 0.5 # 50% chance to fire
        }
        events = {
            birth_events.0002
            birth_events.0003
        }
    }
    on_action = {
        on_action = dynasty_birth_on_actions
    }
}
```

## Modifiers

Modifiers affect character stats, title values, and other game attributes:

```
modifier = {
    monthly_prestige = 0.5
    monthly_piety = 0.5
    diplomacy = 2
    stewardship = -1
    fertility = 0.1
    health = 0.5
    stress_gain_mult = -0.1
}
```

## Best Practices

1. **Use Nested Scope Changes Carefully**: Too many nested scopes make code hard to read
2. **Save Complex Scopes**: Use `save_scope_as` for scopes you need multiple times
3. **Comment Your Code**: Add comments for complex logic blocks
4. **Check Edge Cases**: Add validations to prevent script errors
5. **Use Logging**: Add debug messages for testing with `log = "message"`
6. **Reuse Code**: Extract common logic into scripted effects and triggers

## Examples

### Scripted Effect
```
my_mod_give_appropriate_trait = {
    if = {
        limit = {
            prowess > 10
        }
        add_trait = brave
    }
    else_if = {
        limit = {
            diplomacy > 10
        }
        add_trait = gregarious
    }
    else = {
        add_trait = humble
    }
}
```

### Scripted Trigger
```
my_mod_can_hold_grand_tournament = {
    is_ruler = yes
    gold > 100
    prestige > 50
    NOT = { has_character_flag = recently_held_tournament }
    realm_size >= 5
}
```

## Character Flag-Based State Machine

Track multi-event progression:

## Reference Documentation

For detailed lists of all available effects and triggers, refer to:
- `effects_detailed.json` - Complete effects documentation
- `triggers_detailed.json` - Complete triggers documentation
- `on_actions_detailed.json` - Complete on-actions documentation
- `event_targets_detailed.json` - Event target reference
- `modifiers_detailed.json` - Game modifiers reference 