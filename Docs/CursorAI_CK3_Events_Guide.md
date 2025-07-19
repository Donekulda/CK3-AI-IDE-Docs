# Crusader Kings 3 Events Guide for Cursor AI

This guide covers the events system in Crusader Kings 3 to help Cursor AI assist with event scripting and storytelling.

## Table of Contents
- [Event Structure and Basics](#event-structure-and-basics)
- [Event Portraits and Visuals](#event-portraits-and-visuals)
- [Event Storytelling and Chains](#event-storytelling-and-chains)
- [Tracking Event Progress](#tracking-event-progress)
- [Conditional Branching and Merging](#conditional-branching-and-merging)
- [Event Widgets and Custom UI](#event-widgets-and-custom-ui)
- [On-Action Integration](#on-action-integration)
- [Event Cooldowns and Random Weight](#event-cooldowns-and-random-weight)
- [AI Decision-Making System](#ai-decision-making-system)
- [Localization for Events](#localization-for-events)
- [Testing and Debugging](#testing-and-debugging)
- [Best Practices](#best-practices)
- [Quick Reference](#quick-reference)

## Event Structure and Basics

Events in CK3 are defined in `.txt` files within the `events/` directory and follow this structure:

```txt
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
- `character_event` - Standard event popup with character portraits
- `letter_event` - Event in letter format, good for distant communications
- `court_event` - Event in the royal court interface, immersive court scenes
- `activity_event` - Event during activities like hunts, feasts, pilgrimages
- `unit_event` - Event for military units during campaigns
- `province_event` - Event affecting specific provinces or locations
- `realm_event` - Event affecting entire realms or kingdoms

### Event Fields
- **type**: Determines the event window style and behavior
- **title/desc**: Localization keys for text display
- **theme**: Visual theme for the event window (affects background, icons)
- **trigger**: Conditions for event eligibility (must be true for event to fire)
- **immediate**: Effects that happen when event fires, before options are shown
- **option**: Choices available to the player/AI with associated effects
- **after**: Effects executed after the event ends, regardless of choice
- **cooldown**: Prevents event from firing too frequently
- **hidden**: Hides event from player (for background events)
- **is_triggered_only**: Event only fires when explicitly triggered

## Event Portraits and Visuals

### Portrait Blocks
```txt
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
- `personality_bold` - Confident, assertive expression
- `personality_honorable` - Noble, dignified expression
- `personality_rational` - Thoughtful, calculating expression
- `worry` - Concerned, anxious expression
- `anger` - Furious, aggressive expression
- `grief` - Sad, mournful expression
- `happiness` - Joyful, pleased expression
- `disgust` - Repulsed, disdainful expression
- `surprise` - Shocked, astonished expression
- `contempt` - Scornful, dismissive expression
- `fear` - Terrified, frightened expression
- `neutral` - Calm, expressionless face

### Event Themes
```txt
theme = {
    background = "stone_backdrop"
    icon = "hunting"
}
```

Common themes:
- `councillor` - Court politics and administration
- `intrigue` - Secret plots and schemes
- `diplomacy` - Negotiations and treaties
- `religion` - Faith and spiritual matters
- `martial` - Warfare and military affairs
- `wilderness` - Nature and outdoor activities
- `rumor` - Gossip and hearsay
- `mystery` - Unknown and supernatural events
- `celebration` - Festivals and joyous occasions
- `tragedy` - Sad and unfortunate events
- `romance` - Love and relationships
- `trade` - Commerce and economic matters

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
```txt
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

```txt
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

```txt
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
```txt
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
```txt
add_character_flag = {
    flag = recent_event
    days = 365 # Expires after a year
}
```

### Variables
For numerical progression:
```txt
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
```txt
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

```txt
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

```txt
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

## Event Scopes and Targets

Understanding scopes is crucial for event scripting. Scopes define what objects (characters, provinces, etc.) the event can interact with.

### Common Event Scopes
- **root** - The primary character the event is about (usually the player or target)
- **FROM** - The character who triggered the event (in on_action events)
- **FROMFROM** - The character who triggered the event that triggered this event
- **scope:target** - A saved scope reference to another character/object
- **liege** - The character's liege lord
- **spouse** - The character's spouse
- **father** - The character's father
- **mother** - The character's mother
- **primary_heir** - The character's primary heir
- **capital_province** - The character's capital province
- **capital_barony** - The character's capital barony

### Scope Examples
```txt
# Reference the event target
scope:target = {
    add_prestige = 50
}

# Reference the character's liege
liege = {
    add_opinion_modifier = {
        target = root
        modifier = opinion_helped_me
    }
}

# Reference the character's spouse
spouse = {
    add_stress = 10
}
```

### Saving and Using Scopes
```txt
immediate = {
    # Save a random courtier as a scope
    random_courtier = {
        limit = {
            is_adult = yes
            opinion = { target = root value > 0 }
        }
        save_scope_as = helpful_courtier
    }
}

option = {
    name = my_mod.0001.a
    # Use the saved scope
    scope:helpful_courtier = {
        add_prestige = 25
    }
}
```

## Event Widgets and Custom UI

Create interactive elements in events:
```txt
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
```txt
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
```txt
my_mod.7000 = {
    # ...
    cooldown = {
        days = 180 # Six-month cooldown
    }
}
```

### Random Weight
Control chance of an event firing within random event lists:
```txt
random_events = {
    100 = my_mod.8000 # Higher weight, more likely
    50 = my_mod.8001
    25 = my_mod.8002 # Lower weight, less likely
}
```

## AI Decision-Making System

The AI decision-making system determines how AI characters choose between different options using a sophisticated weighting mechanism.

### Basic AI Chance Structure

Every event option can include an `ai_chance` block that determines the AI's likelihood of selecting that option:

```txt
option = {
    name = my_mod.0001.a
    ai_chance = {
        base = 100
        ai_value_modifier = {
            ai_boldness = 1
            ai_vengefulness = 0.5
        }
    }
}
```

### Core Components

#### Base Value
The `base` parameter sets the starting weight for the option. This is just the initial value - the final weight used for comparison includes all modifiers applied to this base value. The final calculated values of all `ai_chance` blocks are summed up, then each option's final weight is divided by the total to get its statistical chance.

```txt
ai_chance = {
    base = 100  # Starting weight of 100
}
```

**Example with multiple options:**
```txt
option = {
    name = my_mod.0001.a
    ai_chance = {
        base = 200  # Starting weight: 200
        ai_value_modifier = {
            ai_boldness = 1.5  # Adds 1.5 * boldness_value
        }
        modifier = {
            add = 50  # Adds 50
        }
    }
}

option = {
    name = my_mod.0001.b
    ai_chance = {
        base = 50   # Starting weight: 50
        ai_value_modifier = {
            ai_compassion = 2.0  # Adds 2.0 * compassion_value
        }
    }
}
```

**Calculation (assuming boldness=10, compassion=8):**
- Option A final weight = 200 + (1.5 × 10) + 50 = 265
- Option B final weight = 50 + (2.0 × 8) = 66
- Total weight = 265 + 66 = 331
- Option A probability = 265/331 ≈ 80%
- Option B probability = 66/331 ≈ 20%

#### AI Value Modifiers
Adjust chance based on character's AI personality values:
```txt
ai_value_modifier = {
    ai_boldness = 1.0      # Multiplier for boldness trait
    ai_vengefulness = 0.5  # Multiplier for vengefulness trait
    ai_compassion = 2.0    # Multiplier for compassion trait
    ai_honor = 1.5         # Multiplier for honor trait
    ai_rationality = 0.8   # Multiplier for rationality trait
    ai_energy = 1.2        # Multiplier for energy trait
    ai_greed = 0.7         # Multiplier for greed trait
}
```

**Common AI Values:**
- `ai_boldness` - Affects risk-taking decisions
- `ai_vengefulness` - Influences revenge-seeking behavior
- `ai_compassion` - Affects merciful or kind choices
- `ai_honor` - Influences honorable or dishonorable actions
- `ai_rationality` - Affects logical vs emotional decisions
- `ai_energy` - Influences active vs passive choices
- `ai_greed` - Affects material gain vs other considerations

### Advanced Modifiers

#### Factor Modifiers
Use `factor` to multiply the current weight by a specific value. Everything else in the modifier block is a trigger condition:

```txt
ai_chance = {
    base = 100
    modifier = {
        factor = 2.0      # Doubles the weight (final: 200)
        has_trait = brave # TRIGGER: Only applies if character has brave trait
    }
}

ai_chance = {
    base = 100
    modifier = {
        factor = 0.5      # Halves the weight (final: 50)
        has_trait = coward # TRIGGER: Only applies if character has coward trait
    }
}

ai_chance = {
    base = 100
    modifier = {
        factor = 0        # Makes this option impossible for AI (final: 0)
        faith = { has_doctrine_parameter = no_unfaithfulness_penalty_active } # TRIGGER: Only applies in polyamorous faiths
    }
}
```

#### Additive Modifiers
Use `add` to add or subtract a flat value to the weight. Everything else in the modifier block is a trigger condition:

```txt
ai_chance = {
    base = 100
    modifier = {
        add = 50   # Adds 50 to the weight (final: 150)
        faith = { has_doctrine_parameter = no_unfaithfulness_penalty_active }
    }
}

ai_chance = {
    base = 100
    modifier = {
        add = -50  # Subtracts 50 from the weight (final: 50)
        has_trait = coward
    }
}
```

#### Compare Modifiers
Adjust weight based on comparing AI values:
```txt
ai_chance = {
    base = 20
    compare_modifier = {
        value = ai_vengefulness
        trigger = {
            opinion = {
                target = scope:real_father
                value < 0
            }
            ai_vengefulness > 0
        }
    }
}
```

#### Target-Specific Modifiers
Modify AI chance based on the target character's AI values:
```txt
ai_chance = {
    base = 100
    ai_boldness_target_modifier = { VALUE = 50 }
}
```

### Combining Modifiers

Multiple modifiers can be applied to the same option, and they work together to create the final weight:

```txt
ai_chance = {
    base = 100
    ai_value_modifier = {
        ai_boldness = 1.5      # Adds 1.5 * boldness_value
        ai_compassion = 0.5    # Adds 0.5 * compassion_value
    }
    modifier = {
        factor = 0.8           # Multiplies by 0.8 (reduces by 20%)
        has_trait = cautious   # TRIGGER: Only applies if cautious
    }
    modifier = {
        add = -25              # Subtracts 25
        is_at_war = yes        # TRIGGER: Only applies if at war
    }
}
```

**Calculation example (assuming boldness=10, compassion=8, character is cautious and at war):**
- Start: 100
- AI modifiers: + (1.5 × 10) + (0.5 × 8) = + 15 + 4 = 119
- Factor modifier: 119 × 0.8 = 95.2 (applied because character is cautious)
- Additive modifier: 95.2 - 25 = 70.2 (applied because character is at war)
- **Final weight: 70.2**

**Calculation example (assuming boldness=10, compassion=8, character is NOT cautious and NOT at war):**
- Start: 100
- AI modifiers: + (1.5 × 10) + (0.5 × 8) = + 15 + 4 = 119
- Factor modifier: NOT applied (character is not cautious)
- Additive modifier: NOT applied (character is not at war)
- **Final weight: 119**

### Modifier Order of Operations

1. **Start with base value**
2. **Apply AI value modifiers** (additive)
3. **Apply factor modifiers** (multiplicative)
4. **Apply additive modifiers** (additive)

**Important:** Factor modifiers multiply the current value, while additive modifiers add/subtract from it. This order matters for complex calculations.

### Modifier Trigger System

In modifier blocks, everything that isn't a mathematical operation (`add`, `factor`, `value`, `base`) is a **trigger condition**. These triggers determine whether the modifier should be applied:

```txt
modifier = {
    add = 100              # MATHEMATICAL: Adds 100 to weight
    factor = 0.5           # MATHEMATICAL: Multiplies weight by 0.5
    has_trait = brave      # TRIGGER: Only applies if character has brave trait
    is_at_war = yes        # TRIGGER: Only applies if character is at war
    faith = {              # TRIGGER: Only applies if faith has specific doctrine
        has_doctrine_parameter = no_unfaithfulness_penalty_active
    }
}
```

**How it works:**
- If **ALL** trigger conditions are true → modifier is applied
- If **ANY** trigger condition is false → modifier is ignored
- Multiple triggers in the same modifier block use AND logic

**Examples:**

```txt
# Simple trigger - only applies to brave characters
modifier = {
    factor = 2.0
    has_trait = brave
}

# Multiple triggers - only applies to brave characters who are at war
modifier = {
    add = 50
    has_trait = brave
    is_at_war = yes
}

# Complex trigger - only applies to characters with specific faith and trait
modifier = {
    factor = 0
    has_trait = honest
    faith = { has_doctrine_parameter = no_unfaithfulness_penalty_active }
}
```

### Complex AI Decision Examples

#### Example 1: Blackmail Response
```txt
option = {
    name = blackmail.1001.a
    ai_chance = {
        base = 100
        ai_value_modifier = {
            ai_boldness = 1      # Bold characters more likely to use blackmail
            ai_vengefulness = 0.5 # Vengeful characters somewhat likely
        }
    }
}

option = {
    name = blackmail.1001.b
    ai_chance = {
        base = 50
        ai_value_modifier = {
            ai_compassion = 2    # Compassionate characters much more likely
            ai_honor = 1         # Honorable characters somewhat likely
        }
    }
}
```

#### Example 2: Pregnancy Confession
```txt
option = {
    name = pregnancy.2001.a
    ai_chance = {
        base = 20
        ai_value_modifier = {
            ai_honor = 0.5
            ai_boldness = 0.5
            ai_compassion = 0.25
        }
        compare_modifier = {
            value = ai_vengefulness
            trigger = {
                opinion = {
                    target = scope:real_father
                    value < 0
                }
                ai_vengefulness > 0
            }
        }
    }
}
```

#### Example 3: Witchcraft Conversion
```txt
option = {
    name = witch.1002.a
    ai_chance = {
        base = 100
        ai_boldness_target_modifier = { VALUE = 50 }
        modifier = {
            scope:child = {
                exists = house
                house = { has_house_modifier = witch_coven }
                is_ai = no
            }
            add = 1000  # Player children of witch covens always asked
        }
    }
}

option = {
    name = witch.1002.b
    ai_chance = {
        base = 0
        ai_boldness_target_modifier = { VALUE = -100 }
        modifier = {
            exists = liege
            OR = {
                trait_is_criminal_in_faith_trigger = { 
                    TRAIT = witch 
                    FAITH = liege.faith 
                    GENDER_CHARACTER = root 
                }
            }
            add = 100
        }
    }
}
```

### AI Decision Calculation Process

1. **Start with base value**: Each option begins with its base weight
2. **Apply AI value modifiers**: Each AI personality value is multiplied by its modifier and added to the base
3. **Apply conditional modifiers**: Factor, add, and compare modifiers are processed and applied
4. **Calculate final weight per option**: All modifiers are combined into a final weight for each option
5. **Sum all final weights**: Add up the final calculated weights of all available options
6. **Normalize to probabilities**: Each option's final weight is divided by the total to get its statistical chance

**Important:** It's the **final calculated values** of each `ai_chance` block that are compared, not just the base values. The base is just the starting point.

**Example with modifiers:**
```txt
option = {
    name = my_mod.0001.a
    ai_chance = {
        base = 100
        ai_value_modifier = {
            ai_boldness = 1.5  # Adds 1.5 * boldness_value
        }
        modifier = {
            add = 50  # Adds 50 to the weight
        }
    }
}

option = {
    name = my_mod.0001.b
    ai_chance = {
        base = 50
        ai_value_modifier = {
            ai_compassion = 2.0  # Adds 2.0 * compassion_value
        }
    }
}
```

**Calculation (assuming boldness=10, compassion=8):**
- Option A final weight = 100 + (1.5 × 10) + 50 = 165
- Option B final weight = 50 + (2.0 × 8) = 66
- Total weight = 165 + 66 = 231
- Option A probability = 165/231 ≈ 71.4%
- Option B probability = 66/231 ≈ 28.6%

### Best Practices for AI Decision Design

#### 1. Balanced Base Values
```txt
# Good: Balanced options (50/50 chance if no modifiers)
ai_chance = { base = 100 }  # Option A
ai_chance = { base = 100 }  # Option B

# Good: Slight preference (67/33 chance if no modifiers)
ai_chance = { base = 200 }  # Option A
ai_chance = { base = 100 }  # Option B

# Avoid: Extreme imbalances (99/1 chance if no modifiers)
ai_chance = { base = 1000 } # Option A (overwhelming)
ai_chance = { base = 1 }    # Option B (negligible)

# Note: Final probabilities depend on all modifiers, not just base values
```

#### 2. Meaningful AI Value Modifiers
```txt
# Good: Clear personality influence
ai_chance = {
    base = 50
    ai_value_modifier = {
        ai_compassion = 2.0  # Compassionate characters strongly prefer this
        ai_honor = 1.5       # Honorable characters somewhat prefer this
    }
}
```

#### 3. Contextual Modifiers
```txt
# Good: Considers game state
ai_chance = {
    base = 100
    modifier = {
        factor = 0  # Impossible under certain conditions
        faith = { has_doctrine_parameter = no_unfaithfulness_penalty_active }
    }
}
```

### Testing AI Decisions

#### Debug Commands
```txt
# Test AI decision making
debug_mode
event my_mod.0001 # Fire specific event
```

#### Logging AI Decisions
```txt
immediate = {
    log = "AI chose option A with weight: [calculated_weight]"
}
```

### Common AI Decision Patterns

#### 1. Risk vs Reward
```txt
# High risk, high reward option
ai_chance = {
    base = 30
    ai_value_modifier = {
        ai_boldness = 2.0
        ai_greed = 1.5
    }
}

# Safe, low reward option
ai_chance = {
    base = 70
    ai_value_modifier = {
        ai_rationality = 1.5
        ai_compassion = 1.0
    }
}
```

#### 2. Personality-Driven Choices
```txt
# Aggressive option
ai_chance = {
    base = 50
    ai_value_modifier = {
        ai_boldness = 2.0
        ai_vengefulness = 1.5
    }
}

# Diplomatic option
ai_chance = {
    base = 50
    ai_value_modifier = {
        ai_compassion = 2.0
        ai_honor = 1.5
    }
}
```

#### 3. Circumstance-Based Decisions
```txt
# Option available only under specific conditions
ai_chance = {
    base = 0
    modifier = {
        add = 100
        has_trait = brave
        is_at_war = yes
    }
}

# Option heavily penalized under certain conditions
ai_chance = {
    base = 100
    modifier = {
        factor = 0.3  # Reduces to 30% of original weight
        has_trait = coward
    }
    modifier = {
        add = -50     # Further reduces by 50
        is_at_war = yes
    }
}
```

#### 4. Risk Mitigation Patterns
```txt
# High-risk option with personality-based penalties
ai_chance = {
    base = 50
    ai_value_modifier = {
        ai_boldness = 2.0      # Bold characters prefer this
    }
    modifier = {
        factor = 0.5           # Halves the weight for everyone
        has_trait = cautious
    }
    modifier = {
        add = -30              # Further penalty
        is_married = yes       # Married characters are more cautious
    }
}

# Safe option with personality-based bonuses
ai_chance = {
    base = 100
    ai_value_modifier = {
        ai_rationality = 1.5   # Rational characters prefer this
    }
    modifier = {
        factor = 1.5           # 50% bonus for cautious characters
        has_trait = cautious
    }
    modifier = {
        add = 25               # Additional bonus
        is_married = yes       # Married characters prefer safety
    }
}
```

This AI decision system allows for complex, personality-driven storytelling where AI characters make choices that feel authentic to their traits and circumstances, creating more immersive and dynamic gameplay experiences.

## Localization for Events

Events require proper localization entries:
```yaml
# In localization/english/my_mod_events_l_english.yml
l_english:
 my_mod.0001.t:0 "The Discovery"
 my_mod.0001.desc:0 "Your advisors have uncovered an ancient text that speaks of a powerful artifact hidden in the mountains of [location.GetName]."
 my_mod.0001.a:0 "We must find it!"
 my_mod.0001.b:0 "This is a waste of time."
```

### Dynamic Text
Use dynamic references:
```yaml
my_mod.0002.desc:0 "The [ROOT.GetCharacter.GetFaith.GetName] clergy are outraged by your actions!"
```

## Testing and Debugging

### Debug Mode
Enable debug mode in the game to test events more easily:
```txt
debug_mode
event my_mod.0001 # Fire specific event
```

### Log Messages
Add log entries to track execution:
```txt
immediate = {
    log = "Event my_mod.0001 fired for [ROOT.GetCharacter.GetName]"
}
```

### Troubleshooting Common Issues

#### Event Not Firing
1. **Check trigger conditions** - Ensure all conditions in the trigger block are met
2. **Verify namespace is correct** - Namespace must match the event ID prefix
3. **Ensure file is in the right directory** - Events must be in `events/` folder
4. **Check for syntax errors** - Missing braces, commas, or invalid syntax
5. **Verify file is loaded** - Check mod load order and file inclusion
6. **Check cooldown** - Event might be on cooldown from previous firing
7. **Verify on_action integration** - If triggered by on_action, check the on_action file

#### AI Making Unexpected Choices
1. **Review ai_chance calculations** - Check base values and all modifiers
2. **Check modifier trigger conditions** - Ensure triggers are properly formatted
3. **Verify AI personality values** - AI values range from -100 to +100
4. **Test with different character types** - Different traits affect AI decisions
5. **Check for conflicting modifiers** - Multiple modifiers can interact unexpectedly
6. **Verify scope references** - Ensure target scopes exist and are valid

#### Event Chain Breaking
1. **Verify flag names are consistent** - Check spelling and case sensitivity
2. **Check event IDs in trigger_event calls** - Ensure IDs match exactly
3. **Ensure scope variables are properly saved** - Use save_scope_as before referencing
4. **Test each event in the chain individually** - Use debug commands to fire events
5. **Check for missing trigger conditions** - Later events need proper triggers
6. **Verify timing delays** - Days parameter affects when events fire

#### Localization Issues
1. **Check localization file format** - Must be YAML format with proper indentation
2. **Verify key names match** - Event keys must match localization keys exactly
3. **Check for special characters** - Escape quotes and special characters properly
4. **Verify file encoding** - Use UTF-8 encoding for proper character display
5. **Check gender variations** - Use GetWomanMan constructs for gender-specific text

#### Performance Issues
1. **Avoid excessive character iteration** - Use targeted scope selection
2. **Limit frequent event checks** - Use cooldowns and appropriate triggers
3. **Optimize trigger conditions** - Use efficient checks and avoid complex logic
4. **Check for infinite loops** - Ensure event chains have proper exit conditions
5. **Monitor event frequency** - Too many events can slow down the game

#### Debug Commands for Testing
```txt
# Enable debug mode
debug_mode

# Fire specific event
event my_mod.0001

# Fire event for specific character
event my_mod.0001 [character_id]

# Check character flags
charinfo [character_id]

# Check character variables
charinfo [character_id]

# Test AI decision making
ai_chance_debug

# Check event triggers
trigger_debug
```

## Best Practices

### 1. Modular Design
- Create reusable event patterns
- Split complex storylines into smaller event chains
- Use consistent naming conventions

### 2. Performance
- Avoid excessive checks in frequently triggered events
- Use targeted character selection instead of iterating all characters
- Implement appropriate cooldowns

### 3. Balanced Storytelling
- Mix short-term and long-term consequences
- Include both beneficial and challenging outcomes
- Provide meaningful choices with tradeoffs

### 4. Localization Integration
- Create localization keys for all text elements
- Use dynamic text with ROOT/FROM references
- Support gender variations with GetWomanMan constructs

### 5. Quality Control
- Test with different character types
- Verify all branches of event chains
- Check for spelling and grammar in localization

## Quick Reference

### Event Structure Template
```txt
namespace = my_mod_name
my_mod_name.0001 = {
    type = character_event
    title = my_mod_name.0001.t
    desc = my_mod_name.0001.desc
    theme = theme_key
    
    trigger = {
        # Conditions
    }
    
    immediate = {
        # Pre-option effects
    }
    
    option = {
        name = my_mod_name.0001.a
        # Option effects
    }
}
```

### Common Trigger Conditions
```txt
# Character status
trigger = {
    is_ruler = yes                    # Is a ruler
    is_ai = yes                       # Is AI-controlled
    is_player = yes                   # Is player-controlled
    is_adult = yes                    # Is 16 or older
    is_child = yes                    # Is under 16
    is_married = yes                  # Is married
    is_single = yes                   # Is unmarried
    is_at_war = yes                   # Is currently at war
    is_imprisoned = yes               # Is imprisoned
    is_injured = yes                  # Has injury trait
    is_incapable = yes                # Is incapable of ruling
    
    # Traits
    has_trait = brave                 # Has specific trait
    has_trait_group = personality     # Has trait from group
    NOT = { has_trait = coward }      # Does NOT have trait
    
    # Attributes
    martial >= 10                     # Martial skill 10+
    diplomacy >= 8                    # Diplomacy skill 8+
    stewardship >= 12                 # Stewardship skill 12+
    intrigue >= 6                     # Intrigue skill 6+
    learning >= 8                     # Learning skill 8+
    
    # Resources
    prestige >= 1000                  # Has 1000+ prestige
    piety >= 500                      # Has 500+ piety
    gold >= 200                       # Has 200+ gold
    
    # Relationships
    opinion = { target = liege value > 0 }  # Positive opinion of liege
    opinion = { target = spouse value < -50 } # Negative opinion of spouse
    
    # Flags and variables
    has_character_flag = quest_started
    has_variable = story_progress
    var:story_progress >= 3
    
    # Faith and culture
    faith = { has_doctrine_parameter = some_doctrine }
    culture = { has_innovation = some_innovation }
    
    # Geographic
    is_in_capital = yes               # Is in capital
    is_in_realm = { target = liege }  # Is in liege's realm
    location = { is_capital = yes }   # Current location is capital
}
```

### Common Effects
```txt
# Character attributes and resources
add_prestige = 100                    # Add prestige points
add_piety = 50                        # Add piety points
add_gold = 200                        # Add gold
add_stress = 10                       # Add stress (0-400 scale)
remove_stress = 20                    # Remove stress
add_health = 0.5                      # Add health (affects lifespan)
add_fertility = 0.1                   # Add fertility bonus

# Traits
add_trait = brave                     # Add specific trait
remove_trait = coward                 # Remove specific trait
add_trait_group = personality         # Add random trait from group

# Skills and experience
add_skill = {                         # Add skill experience
    type = martial
    value = 100
}
add_skill = {                         # Add multiple skills
    type = diplomacy
    value = 50
}
add_skill = {                         # Add all skills
    type = stewardship
    value = 25
}
add_skill = {                         # Add intrigue
    type = intrigue
    value = 75
}
add_skill = {                         # Add learning
    type = learning
    value = 30
}

# Relationships and opinions
opinion = {                           # Modify opinion
    target = scope:target
    value = 10
    years = 10                        # Duration in years
}
add_opinion_modifier = {              # Add opinion modifier
    target = scope:target
    modifier = opinion_helped_me
    years = 5
}
remove_opinion_modifier = {           # Remove opinion modifier
    target = scope:target
    modifier = opinion_helped_me
}

# Character flags and variables
add_character_flag = quest_completed
remove_character_flag = quest_active
set_variable = {                      # Set variable
    name = story_stage
    value = 3
}
change_variable = {                   # Modify variable
    name = story_stage
    add = 1
}

# Event chaining and timing
trigger_event = {                     # Trigger another event
    id = my_mod.0002
    days = 7                          # Delay in days
}
trigger_event = {                     # Trigger immediately
    id = my_mod.0003
}

# Character interactions
imprison = scope:target               # Imprison character
release = scope:target                # Release from prison
execute = scope:target                # Execute character
banish = scope:target                 # Banish character

# Titles and holdings
grant_title = {                       # Grant title
    title = d_england
    target = scope:heir
}
revoke_title = {                      # Revoke title
    title = d_england
    target = scope:vassal
}

# Pregnancy and children
impregnate = scope:spouse             # Make spouse pregnant
add_character_modifier = {            # Add temporary modifier
    name = pregnancy_modifier
    duration = 270                    # 9 months
}

# Court and council
add_courtier = scope:character        # Add to court
remove_courtier = scope:character     # Remove from court
appoint_council_position = {          # Appoint to council
    position = chancellor
    target = scope:character
}

# Military
add_men_at_arms = {                   # Add military units
    type = heavy_infantry
    amount = 100
}
add_men_at_arms = {                   # Add knights
    type = knights
    amount = 5
}

# Artifacts and items
add_artifact = scope:artifact         # Add artifact to inventory
remove_artifact = scope:artifact      # Remove artifact
create_artifact = {                   # Create new artifact
    type = crown
    tier = 1
}
```

### AI Chance Template
```txt
ai_chance = {
    base = 100
    ai_value_modifier = {
        ai_boldness = 1.5
        ai_compassion = 0.5
    }
    modifier = {
        factor = 2.0
        has_trait = brave
    }
    modifier = {
        add = -50
        is_at_war = yes
    }
}
```

## Example: Complete Event Storyline

```txt
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