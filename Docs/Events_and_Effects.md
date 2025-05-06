# CK3 Modding: Events, Effects, and Game Mechanics

## Events and Event Structure

Events are the primary way to create dynamic gameplay in CK3. They are defined in `.txt` files within the `events/` directory and follow a specific structure:

```pdx
namespace = my_mod
my_event.1 = {
    type = character_event
    title = my_event.title
    desc = my_event.desc
    
    trigger = {
        # Conditions for event to fire
    }
    
    immediate = {
        # Effects that happen immediately when event fires
    }
    
    option = {
        name = my_event.option_a
        # Effects when this option is chosen
    }
}
```

## Event Scopes and Targets

### Scopes
Scopes define the context in which an event or effect operates. The main scopes in CK3 are:

- `character`: A character in the game
- `title`: A landed title (kingdom, duchy, etc.)
- `province`: A province on the map
- `realm`: A ruler's domain
- `dynasty`: A family line
- `culture`: A cultural group
- `religion`: A religious group
- `war`: An ongoing conflict
- `court`: A ruler's court

### Event Targets
Event targets are special scopes that can be referenced within events:

- `root`: The primary scope of the event
- `from`: The character who triggered the event
- `fromfrom`: The character who triggered the event that triggered this event
- `actor`: The character performing the action
- `recipient`: The character receiving the action

Example:
```pdx
my_event.1 = {
    type = character_event
    # root scope is the character the event is happening to
    # from scope is the character who triggered it
    
    option = {
        name = my_event.option_a
        add_opinion_modifier = {
            target = from
            opinion = 10
            years = 5
        }
    }
}
```

## Effects

Effects are actions that can be performed in events, decisions, and other game mechanics. They are the "verbs"/functions of CK3 modding. 

Common effects include:

- Character Effects:
  ```pdx
  add_trait = trait_brave
  add_gold = 100
  add_prestige = 50
  add_piety = 25
  add_stress = 10
  ```

- Title Effects:
  ```pdx
  grant_title = title:d_k_england
  destroy_title = title:d_k_england
  ```

- Relationship Effects:
  ```pdx
  add_opinion_modifier = {
      target = from
      opinion = 10
      years = 5
  }
  add_relation_effect = {
      target = from
      effect = friend
  }
  ```

- Event Effects:
  ```pdx
  trigger_event = {
      id = my_event.2
      days = 10
  }
  ```

## Modifiers

Modifiers are values that affect various aspects of the game. They can be applied to characters, titles, provinces, and other scopes.

### Modifier Structure
```pdx
modifier_name = {
    value = 10
    years = 5
    stacking = yes
}
```

### Common Modifier Types
- Character Modifiers:
  ```pdx
  monthly_prestige = 0.5
  monthly_piety = 0.5
  monthly_gold = 1.0
  fertility = 0.5
  health = 1.0
  ```

- Title Modifiers:
  ```pdx
  monthly_development = 0.1
  monthly_control = 0.1
  ```

- Province Modifiers:
  ```pdx
  development_growth = 0.1
  supply_limit = 1000
  ```

## On Actions

On Actions are special triggers that fire when specific game events occur. They are defined in `common/on_action/` files.

Common On Actions:
```pdx
on_character_birth = {
    events = {
        my_mod.1000
    }
}

on_character_death = {
    events = {
        my_mod.1001
    }
}

on_war_ended = {
    events = {
        my_mod.1002
    }
}
```

## Triggers

Triggers are conditions that determine whether an event can fire or an option is available. They return true or false.

### Common Triggers
```pdx
trigger = {
    # Character triggers
    is_alive = yes
    is_adult = yes
    is_female = yes
    has_trait = trait_brave
    
    # Title triggers
    has_title = title:k_england
    is_landed = yes
    
    # Relationship triggers
    has_opinion_modifier = {
        target = from
        modifier = opinion_friend
    }
    
    # Resource triggers
    gold >= 100
    prestige >= 50
    
    # Complex triggers
    OR = {
        has_trait = trait_brave
        has_trait = trait_zealous
    }
    AND = {
        is_adult = yes
        is_female = yes
    }
    NOT = {
        has_trait = trait_craven
    }
}
```

### Trigger Operators
- `AND`: All conditions must be true
- `OR`: At least one condition must be true
- `NOT`: The condition must be false
- `NOR`: None of the conditions can be true
- `NAND`: Not all conditions can be true

### Scope Triggers
```pdx
trigger = {
    any_character = {
        count = 2
        is_adult = yes
        is_female = yes
    }
    any_realm_province = {
        count = 3
        development >= 10
    }
}
```

## Best Practices

1. **Scope Management**
   - Always be aware of which scope you're in
   - Use `save_scope_as` to store important scopes
   - Use `save_temporary_scope_as` for temporary scope storage

2. **Event Design**
   - Keep events focused and specific
   - Use clear, descriptive names
   - Include appropriate triggers to prevent spam
   - Add cooldowns for frequently occurring events

3. **Modifier Usage**
   - Use appropriate stacking rules
   - Set reasonable durations
   - Consider balance implications
   - Use descriptive names

4. **Trigger Efficiency**
   - Order triggers from least to most expensive
   - Use appropriate operators
   - Avoid redundant conditions
   - Cache complex calculations in scripted values

5. **On Action Organization**
   - Group related on actions together
   - Use descriptive event IDs
   - Consider event weight and MTTH
   - Test thoroughly for conflicts 