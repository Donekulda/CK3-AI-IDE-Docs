# Crusader Kings 3 Mod File Structure

## Understanding CK3 Game Mechanics and Modding Workflow

Crusader Kings 3 (CK3) is built on a highly modular and data-driven architecture, making it extremely mod-friendly. The game's mechanics are defined by a combination of plaintext configuration files, scripts, and assets, all organized into a clear directory structure. Here's a detailed look at how the system works and how you can leverage it for modding:

### 1. File and Folder Structure

CK3 organizes its game logic, assets, and data into specific folders, each with a dedicated purpose. This modular approach allows modders to override, extend, or add new content without directly modifying the base game files.

- **common/**: Contains core game rules, definitions, and mechanics. Each subfolder here represents a different system (e.g., governments, laws, traits, scripted effects).
- **events/**: Houses all event definitions and event chains. Events are written in plaintext and can be triggered by in-game actions, conditions, or scripts.
- **gfx/**: Stores all graphical assets, such as textures, icons, models, and portraits.
- **gui/**: Contains user interface definitions, including window layouts, HUD elements, and custom widgets.
- **history/**: Holds historical data, such as character genealogies, province histories, and title lineages.
- **localization/**: Contains all in-game text, organized by language for easy translation and customization.

### 2. File Naming and Load Order

- **Unique Naming**: To prevent conflicts, all files should have unique names, typically using a short prefix (2–5 letters) related to your mod, followed by a number for load order, and a descriptive name.
- **Load Order**: Files are loaded in alphabetical order. Lower numbers load first, so use numbering to control which files override others if necessary.

### 3. Scripting and Game Logic

CK3 uses a custom scripting language for defining game logic, triggers, and effects. These scripts are stored in `.txt` files within the appropriate subfolders (e.g., `scripted_effects/`, `scripted_triggers/`). This allows for:
- **Custom Triggers**: Boolean conditions that determine if certain actions or events can occur.
- **Scripted Effects**: Custom functions that execute when triggered by events, decisions, or other game systems.
- **Dynamic Values**: Use of `script_values/` to define values that can change based on game state.

### 4. Events System

Events are a core part of CK3's storytelling and gameplay. Each event is defined with a unique ID, type, title, description, triggers, and options. Events can:
- Affect characters, realms, or the world.
- Be triggered by player actions, AI decisions, or scripted conditions.
- Include custom GUI widgets, portraits, and dynamic content.

### 5. Visual and UI Customization

- **gfx/**: Add or override visual assets such as icons, backgrounds, and models.
- **gui/**: Modify or create new interface elements, windows, and widgets to enhance user experience or support new mechanics.

### 6. Localization

All in-game text is stored in the `localization/` directory, organized by language. This allows for easy translation and ensures your mod is accessible to a wider audience.

### 7. Modding Workflow

1. **Plan Your Changes**: Decide which systems you want to modify or extend.
2. **Create Unique Files**: Use unique prefixes and numbers for all new files.
3. **Organize Content**: Place files in the correct directories based on their function.
4. **Script and Define**: Write or modify scripts, triggers, and effects as needed.
5. **Add Events and Assets**: Create new events, add graphical assets, and update the UI as required.
6. **Localize**: Add or update localization files for all supported languages.
7. **Test Thoroughly**: Load your mod in-game and test all changes to ensure compatibility and stability.

### 8. Example: Adding a New Trait

Suppose you want to add a new character trait:
- Create a new file in `common/traits/` (e.g., `MYMOD_01_new_trait.txt`).
- Define the trait's properties, triggers, and effects.
- Add an icon to `gfx/interface/traits/`.
- Update localization files with the trait's name and description.
- (Optional) Script events or decisions that interact with the new trait.

---

This structure allows for modular, organized, and powerful modding of CK3, letting you change or expand nearly every aspect of the game.

This document describes the folder and file structure for CK3 modding, including what each folder should contain and how files should be named.

File names should be fully unique, as if they are same as either other mod or main game (Code folder), then it will overwrite it, as the load order states what overwrites what (the latter ones overwrite the foremost ones).
as such they should made from PREFIX - which should be between 2-5 letters long, and should be in some way unique to the mod (for example made up of first letters of each word of the mods name)
and NUMBER which is easiest way to state what load first as, the lower number is sorted sooner, for this reason the file name should look like
PREFIX_NUMBER_some_name_folder_name.txt -> example: WW_00_forge_staff_desicion.txt

Now for the folder structure and what each folder should contain

## Main Directories
- common/
- events/
- gfx/
- gui/
- history/
- localization/

## Common Directory Structure
The common directory contains game rules, definitions, and mechanics:

### Character and Interaction Systems
- character_backgrounds/
- character_interactions/
- character_interaction_categories/
- character_memory_types/
- courtier_guest_management/
- guest_system/
- pool_character_selectors/

### Government and Politics
- governments/
- laws/
- council_positions/
- council_tasks/
- court_types/
- court_positions/
- court_amenities/
- decisions/
- decision_group_types/
- important_actions/

### Titles and Vassals
- landed_titles/
- vassal_contracts/
- vassal_stances/
- lease_contracts/

### Dynasty and Houses
- dynasties/
- dynasty_houses/
- dynasty_house_mottos/
- dynasty_house_motto_inserts/
- dynasty_legacies/
- dynasty_perks/

### Culture and Religion
- culture/
- religion/
- ethnicities/

### Military and Combat
- men_at_arms_types/
- combat_effects/
- combat_phase_events/

### Scripting and Game Logic
- defines/
Contains everything that should be defined before the start of the game, be it map size, how time works, building size, or other definitions how the game should act
- scripted_triggers/
Triggers are from perspective seen as a bool functions, that either return truth or false
- scripted_effects/
Could be called functions as well, every file is named PREFIX_NUMBER_group_name_scripted_effects.txt, and contains Paradox function also called effects
- scripted_rules/
- scripted_guis/
Code for GUI, and its interaction with the rest of the mod
- scripted_lists/
Prescripted lists/arrays that are created with the lunch of the game, based on prespecified rules
- scripted_modifiers/
Dynamicly functioning modifiers for events and ai interaction, every file is named PREFIX_NUMBER_group_name_scripted_modifiers.txt
- scripted_relations/
- scripted_costs/
- scripted_animations/
- scripted_character_templates/
- script_values/
Dynamicly recalculated values, based on setuped script, Useful in events, script, gui, ai weight system and virtually anywhere where the used value should dynamicly change before the use to fit for the situation

### Game Systems
- activities/
- artifacts/
- buildings/
- casus_belli_types/
- focuses/
- game_rules/
- game_concepts/
Contains in-game trivia/wiki link, that when combined with localization for the currently created game concept, and use in some other localization, will show descption (In-game note based wiki)
- lifestyle_perks/
- lifestyles/
- schemes/
- traits/

### Visual and UI Elements
- coat_of_arms/
- genes/
- modifier_icons/
- portrait_types/
- event_backgrounds/
- event_themes/
- event_transitions/
- event_2d_effects/

### Localization and Text
- customizable_localization/
- effect_localization/
- trigger_localization/
- flavorization/
- messages/
- message_group_types/
- message_filter_types/
- nicknames/

### Other Systems
- deathreasons/
- domiciles/
- epidemics/
- factions/
- holdings/
- hook_types/
- inspirations/
- legitimacy/
- legends/
- modifiers/
- on_action/
- struggles/
- suggestions/
- tax_slots/
- terrain_types/
- travel/

## Events Directory Structure
The events directory contains all game events and event chains:

=== Structure ===

This directory contains all event definitions that can occur in the game.
Events can be triggered by various conditions and affect characters, realms, and the game world.

File Format:
- All files should be in plain text (.txt)
- Use UTF-8-BOM encoding
- Each event must have a unique ID
- Events should be properly categorized in subdirectories

Event Structure:
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

Subdirectories:
activities/ - Activity-related events
artifacts/ - Artifact discovery and interaction events
birth_events.txt - Character birth events
court_events/ - Court and royal events
culture_events/ - Cultural events and decisions
death_events.txt - Character death events
decisions_events/ - Decision-triggered events
education_and_childhood/ - Character education events
factions/ - Faction-related events
government_events/ - Government and realm events
health_events.txt - Character health events
interaction_events/ - Character interaction events
lifestyle/ - Lifestyle and focus events
marriage_effect_events.txt - Marriage-related events
prison_events/ - Imprisonment events
religion_events/ - Religious events
scheme_events/ - Scheme and plot events
stress_events/ - Character stress events
war_events/ - War and battle events
yearly_events/ - Regular yearly events

event_namespace.42 = {
	type = character_event/letter_event/court_event/activity_event # Default to character, what type of event this is
	scope = scope_type # Optional, defaults to character, will make this event fire with a different expected root scope. none can be used to have no scopes set up.
	window = window_name # Optional, what special event file and widget in gui/event_windows should this event use, only used for character events

	# If you have a cooldown, the recipient will get a variable saved with that duration. The variable name will be the event ID
	# Anything that checks that an event is legal to fire will also check that the recipient doesn't have that variable
	cooldown = {
		days/weeks/months/years = script value
	}

	# DLC or Mod that this Event belongs to, shown in Event Window if set.
	content_source = X

	# Specify a character portrait to appear in the event on the specified position.
	left_portrait = X
	right_portrait = X
	center_portrait = X # not used in all event types
	lower_left_portrait = X
	lower_center_portrait = X
	lower_right_portrait = X
	sender = X # for letter events, required
	# X can be one of:
		X = event target
		X = {
			character = event target
			trigger = ... # optional, a trigger saying whether this portrait should be visible, in the scope of the portrait character, the event scope is accessible as root scope
			animation = animation name	# optional, the animation to show for this portrait. It's used if no triggered animations pass their trigger. The default animation will be used if nothing is this item is not specified.
			scripted_animation = key_of_scripted_animation # optional, instead of 'animation' you can also define a 'scripted_animation'

			# A list of triggered animations. The first triggered animation that passes the trigger check will be used.
			triggered_animation = {
				trigger = ...
				animation = animation name
				# Instead of 'animation' you can also define a 'scripted_animation'
				scripted_animation = key_of_scripted_animation
			}
			triggered_animation = ...
			
			# A list of triggered outfits. The first triggered otfit that passes the trigger check will be used.
			triggered_outfit = {
				trigger = ...
				outfit_tags = ...
				remove_default_outfit = ...
				hide_info = ...
			}
			triggered_outfit = ...

			# Override camera to be used instead of the normal event ones
			camera = camera_key
			
			outfit_tags = { tag1 tag2 }	# Specifies outfit tags for this portrait in ascending priority (i.e. tag2 will "override" tag1 here if anything with tag2 is found in a specific portrait modifier category)
			remove_default_outfit = yes/no	# If set to yes, portrait modifier categories in which nothing matches any of the event tags will be disabled completely (no by default)
			hide_info = yes/no			# If set to yes, only the portrait will be shown, with no identifiable elements (no CoA, tooltips, clicks...) (no by default)
		}
	
	# Specify an artifact to appear in the event on the specified position
	artifact = {
		target = event target
		position = lower_left_portrait/lower_center_portrait/lower_right_portrait
		# Can't be in the same position as a portrait
		trigger = ... # Optional, as for character portraits
	}

	# This will be run if a queued event (or one triggered immediately from script) does not fulfil its trigger
	# Events failing to trigger from an on-action will *not* run this
	on_trigger_fail = {
		some effect
	}

	# Specify custom widgets to embed in the event. See section about Custom Widgets below.
	widgets = {
		widget = {
			# Trigger that controls the availability of the widget. Scope: same as the event, after immediate effect. Default: always = yes
			is_shown = {}
			# Name of the widget to use. Must be at the path <event_window_widgets>/<widget_name>.gui
			gui = "<widget_name>"
			# Name of the widget where this custome widget will be insert
			container = "<container_widget_name>"
			# Some widgets require a custom controller (see below). Default: default
			controller = <controller_type>
			# Effect to set up the scope as required by the controller. Scope: same as the event, after immediate effect, doesn't modify the event scope, though. Default: {}
			setup_scope = {}
		}
	}
	widget = { ... } 		# alternative syntax for a single widget. Follows the same info as the widget in the widgets parameter
	
	option = { # An option the player/AI can pick
		# Localization key for the event option button text
		name = X
		
		# The effects that will be run when picking the options. Written directly here with no label
		X..

		# A trigger that has to be fulfilled for this option to be valid.
		trigger = {}

		# If the event is invalid, but this trigger is valid, then the option will be shown (but disabled).
		# This behavior is also influenced by the EVENT_OPTIONS_SHOWN_HIDE_UNAVAILABLE or SCHEME_PREPARATION_OPTIONS_SHOWN_HIDE_UNAVAILABLE defines depending on event type.
		show_as_unavailable = {}

		# Highlights the event portrait of this character while this option is hovered. This is in addition to the automatic highlighting when hovering an event option that has an effect that affects portrait characters.
		highlight_portrait = scope:a_character

		reason = <flag> # Special reason for why this option is unlocked, can be any arbitrary string, is be checked in the UI to show special by reason
	}

	theme = ""					# Theme to use in the event. For a list, check: 00_event_themes.txt
	override_background = {		# A background that can be shown when the event pops up. This overrides the theme one. In case that there are multiples the first one that fits the trigger will be the one selected. In case none fits the ones inthe theme will be checked after.
		trigger = {}			# Receives the event scope to check if it's valid.
		reference = "" 			# Path to the texture
	}
	override_transition = {		# A transition that can be shown when the event pops up, before the event options and backgrounds. This overrides the theme one. In case that there are multiples the first one that fits the trigger will be the one selected. In case none fits the ones inthe theme will be checked after.
		trigger = {}			# Receives the event scope to check if it's valid.
		reference = "" 			# Path to the texture
	}
	override_effect_2d = {		# A 2d effect that can be put on top of the background. This overrides the theme one. In case that there are multiples the first one that fits the trigger will be the one selected. In case none fits the ones inthe theme will be checked after.
		trigger = {}			# Receives the event scope to check if it's valid.
		reference = "" 			# key to the effect
	}
	override_icon = {			# An icon that can be shown when the event pops up. This overrides the theme one. In case that there are multiples the first one that fits the trigger will be the one selected. In case none fits the ones inthe theme will be checked after.
		trigger = {}			# Receives the event scope to check if it's valid.
		reference = "" 			# Path to the texture
	}
	override_header_background = { # The header asset located behind the event icon. This overrides the header asset defined by the theme. If there are multiples defined here, the first one that passes its trigger will be selected. If none are valid, then the theme's header asset will be used
		trigger = {}
		reference = ""
	}
	override_sound = {			# A sound that can be played when the event pops up. This overrides the theme one. In case that there are multiples the first one that fits the trigger will be the one selected. In case none fits the ones inthe theme will be checked after.
		trigger = {}			# Receives the event scope to check if it's valid.
		reference = "" 			# Reference of the sound
	}
	orphan = yes 				# The game will not log an error about this event being unreferenced. Useful for debug events
}

=== Custom Widgets ===

Custom widgets can be embedded into events.
GUI files must be placed at the event_window_widgets path (see paths.settings). The name of the file must match the widget name.

Some widgets that modify the game require a custom controller. This should be documented in the widget's GUI file.
The data context type available in the GUI depends on the controller type.

Some controllers require special scope setup, which should be documented under Notes below. Use the setup_scope effect for that.

Available controllers:

Controller Type         | Data Context Name                      | Notes
------------------------+----------------------------------------+-------------------------------------------------------------------------------------------------------------
default                 | EventWindowWidget                      | Default controller, no special behavior
name_character          | EventWindowWidgetNameCharacter         | Changes a character's name. Scope must have the name_character_target saved scope.
text                    | EventWindowWidgetEnterText             | Saves some text onto the character.
event_chain_progress    | EventWindowWidgetChainProgress         | Displays progress through an event chain, needs event_chain_length and event_chain_progress scope values set
struggle_info           | EventWindowCustomWidgetStruggleInfo    | Displays information for the struggle, needs "start" scope value set

### Character Events
- birth_events.txt
- death_events.txt
- education_and_childhood/
- health_events.txt
- pregnancy_events.txt
- trait_specific_events/

### Lifestyle and Activity Events
- activities/
- lifestyles/
- stress_events/
- story_cycles/

### Political and Realm Events
- court_events/
- councillor_task_events/
- decisions_events/
- diarchy_events/
- factions/
- government_events/
- realm_maintenance_events/
- title_events.txt
- war_events/

### Social and Interaction Events
- interaction_events/
- marriage_effect_events.txt
- relations_events/
- secret_events/
- single_combat_events.txt

### Culture and Religion Events
- culture_events/
- religion_events/
- global_culture_events.txt
- global_religion_events.txt

### Game System Events
- artifacts/
- blackmail_events.txt
- court_position_management_events.txt
- game_rule_events.txt
- scheme_events/
- secret_faith_events.txt
- travel_events/

### Notification and Management Events
- notification_events/
- yearly_events/
- error_suppression_events.txt

### Special Events
- bookmark_events.txt
- dlc/
- historical_character_events.txt
- legacy_events/

Note: Each .txt file contains specific event chains, while directories usually contain multiple related event files.

## GFX Directory Structure
The gfx directory contains all graphical assets:

### Visual Assets
- coat_of_arms/ - Coat of arms textures and assets
- court_scene/ - 3D assets for royal court scenes
- interface/ - UI graphics and icons
- map/ - Map textures and terrain graphics
- models/ - 3D models
- particles/ - Particle effects
- portraits/ - Character portrait assets
- skins/ - Character skin textures

### Technical Graphics
- compound_nodes/ - Complex graphical elements
- cursors/ - Mouse cursor graphics
- fonts/ - Font files
- FX/ - Special effects
- lines/ - Line graphics
- schematics/ - Technical drawings and layouts

## GUI Directory Structure
The gui directory contains all user interface definitions:

### Core Windows
- hud.gui - Main game HUD
- hud_bottom.gui - Bottom HUD elements
- hud_top.gui - Top HUD elements
- hud_outliner.gui - Game outliner
- frontend_main.gui - Main menu interface
- console.gui - Debug console interface

### Character and Court Windows
- window_character_finder.gui
- window_court.gui
- window_court_positions.gui
- window_court_events.gui
- window_council.gui

### Activity and Event Windows
- activity_window_widgets/
- activity_locale_widgets/
- event_windows/
- event_window_widgets/

### Gameplay Windows
- window_decisions.gui
- window_war_overview.gui
- window_intrigue.gui
- window_culture.gui
- window_title.gui
- window_dynasty_legacy.gui

### Shared Components
- shared/ - Common UI elements
- scripted_widgets/ - Reusable UI components
- notifications/ - Notification windows
- jomini/ - Engine-specific UI

### Debug and Settings
- debug/ - Debug interface elements
- settings/ - Game settings windows
- map_editor/ - Map editing interface

Note: GUI files (.gui) contain window layouts and interface definitions in a custom scripting language.

## Exact File Structure
This section contains the exact 1:1 file structure as found in the game files.

```
CK_mod_forlder/
├── common/
│   ├── accolade_icons/
│   ├── accolade_names/
│   ├── accolade_types/
│   ├── achievements/
│   ├── activities/
│   ├── ai_goaltypes/
│   ├── ai_war_stances/
│   ├── artifacts/
│   ├── bookmark_portraits/
│   ├── bookmarks/
│   ├── buildings/
│   ├── casus_belli_groups/
│   ├── casus_belli_types/
│   ├── character_backgrounds/
│   ├── character_interaction_categories/
│   ├── character_interactions/
│   ├── character_memory_types/
│   ├── coat_of_arms/
│   ├── combat_effects/
│   ├── combat_phase_events/
│   ├── console_groups/
│   ├── council_positions/
│   ├── council_tasks/
│   ├── court_amenities/
│   ├── court_positions/
│   ├── court_types/
│   ├── courtier_guest_management/
│   ├── culture/
│   ├── customizable_localization/
│   ├── deathreasons/
│   ├── decision_group_types/
│   ├── decisions/
│   ├── defines/
│   ├── diarchies/
│   ├── dna_data/
│   ├── domiciles/
│   ├── dynasties/
│   ├── dynasty_houses/
│   ├── dynasty_house_mottos/
│   ├── dynasty_house_motto_inserts/
│   ├── dynasty_legacies/
│   ├── dynasty_perks/
│   ├── effect_localization/
│   ├── epidemics/
│   ├── ethnicities/
│   ├── event_2d_effects/
│   ├── event_backgrounds/
│   ├── event_themes/
│   ├── event_transitions/
│   ├── factions/
│   ├── flavorization/
│   ├── focuses/
│   ├── game_concepts/
│   ├── game_rules/
│   ├── genes/
│   ├── governments/
│   ├── guest_system/
│   ├── holdings/
│   ├── hook_types/
│   ├── house_power_bonus/
│   ├── house_unities/
│   ├── important_actions/
│   ├── inspirations/
│   ├── landed_titles/
│   ├── laws/
│   ├── lease_contracts/
│   ├── legitimacy/
│   ├── legends/
│   ├── lifestyle_perks/
│   ├── lifestyles/
│   ├── men_at_arms_types/
│   ├── message_filter_types/
│   ├── message_group_types/
│   ├── messages/
│   ├── modifier_definition_formats/
│   ├── modifier_icons/
│   ├── modifiers/
│   ├── named_colors/
│   ├── nicknames/
│   ├── on_action/
│   ├── opinion_modifiers/
│   ├── playable_difficulty_infos/
│   ├── pool_character_selectors/
│   ├── portrait_types/
│   ├── province_terrain/
│   ├── religion/
│   ├── schemes/
│   ├── script_values/
│   ├── scripted_animations/
│   ├── scripted_character_templates/
│   ├── scripted_costs/
│   ├── scripted_effects/
│   ├── scripted_guis/
│   ├── scripted_lists/
│   ├── scripted_modifiers/
│   ├── scripted_relations/
│   ├── scripted_rules/
│   ├── scripted_triggers/
│   ├── secret_types/
│   ├── story_cycles/
│   ├── struggle/
│   ├── succession_appointment/
│   ├── succession_election/
│   ├── suggestions/
│   ├── task_contracts/
│   ├── tax_slots/
│   ├── terrain_types/
│   ├── traits/
│   ├── travel/
│   ├── trigger_localization/
│   ├── tutorial_lesson_chains/
│   ├── tutorial_lessons/
│   ├── vassal_contracts/
│   └── vassal_stances/
├── events/
│   ├── activities/
│   ├── artifacts/
│   ├── birth_events.txt
│   ├── blackmail_events.txt
│   ├── board_game_events.txt
│   ├── bookmark_events.txt
│   ├── bp1_dan_events.txt
│   ├── chad_debug_events.txt
│   ├── councillor_task_events/
│   ├── court_events/
│   ├── court_maintenance_events.txt
│   ├── court_position_management_events.txt
│   ├── courtier_guest_management_events/
│   ├── culture_events/
│   ├── death_events.txt
│   ├── decisions_events/
│   ├── diarchy_events/
│   ├── dlc/
│   ├── easteregg_events.txt
│   ├── education_and_childhood/
│   ├── error_suppression_events.txt
│   ├── factions/
│   ├── game_rule_events.txt
│   ├── global_culture_events.txt
│   ├── global_religion_events.txt
│   ├── government_events/
│   ├── harm_events.txt
│   ├── health_events.txt
│   ├── historical_character_events.txt
│   ├── interaction_events/
│   ├── jester_stress_relief_events.txt
│   ├── legacy_events/
│   ├── lifestyles/
│   ├── marriage_effect_events.txt
│   ├── misc_events.txt
│   ├── nickname_events/
│   ├── notification_events/
│   ├── pregnancy_events.txt
│   ├── prison_events/
│   ├── realm_maintenance_events.txt
│   ├── relations_events/
│   ├── religion_events/
│   ├── scheme_events/
│   ├── secret_events/
│   ├── secret_faith_events.txt
│   ├── siege_events.txt
│   ├── single_combat_events.txt
│   ├── story_cycles/
│   ├── stress_events/
│   ├── test_events/
│   ├── title_events.txt
│   ├── trait_specific_events/
│   ├── travel_events/
│   ├── tutorial_events.txt
│   ├── varangian_events.txt
│   ├── war_events/
│   ├── witch_events.txt
│   └── yearly_events/
├── gfx/
│   ├── FX/
│   ├── coat_of_arms/
│   ├── compound_nodes/
│   ├── court_scene/
│   ├── cursors/
│   ├── exe_icon.bmp
│   ├── fonts/
│   ├── interface/
│   ├── lines/
│   ├── load_settings.settings
│   ├── map/
│   ├── models/
│   ├── particles/
│   ├── portraits/
│   ├── schematics/
│   └── skins/
├── gui/
│   ├── POPS/
│   ├── achievements/
│   ├── activity_locale_widgets/
│   ├── activity_window_widgets/
│   ├── applicationutils/
│   ├── console.gui
│   ├── debug/
│   ├── decision_view_widgets/
│   ├── dynasty_customization_window.gui
│   ├── event_window_widgets/
│   ├── event_windows/
│   ├── frontend_bookmarks.gui
│   ├── frontend_ingame_menu.gui
│   ├── frontend_main.gui
│   ├── game_rules.gui
│   ├── hud.gui
│   ├── hud_bottom.gui
│   ├── hud_outliner.gui
│   ├── hud_sidebars.gui
│   ├── hud_top.gui
│   ├── interaction_court_task.gui
│   ├── interaction_declare_war.gui
│   ├── interaction_grant_titles.gui
│   ├── interaction_interfere_in_war.gui
│   ├── interaction_interfere_in_war_notification.gui
│   ├── interaction_templates.gui
│   ├── jomini/
│   ├── map_editor/
│   ├── multiplayer_serverbrowser.gui
│   ├── multiplayer_setup.gui
│   ├── multiplayer_types.gui
│   ├── notifications/
│   ├── preload/
│   ├── scripted_widgets/
│   ├── settings/
│   ├── shared/
│   ├── shortcuts.shortcuts
│   ├── texticons_religion.gui
│   ├── window_accolade.gui
│   ├── window_activity_guest_list.gui
│   ├── window_activity_intent_selection.gui
│   ├── window_activity_list.gui
│   ├── window_activity_locale.gui
│   ├── window_activity_planner.gui
│   ├── window_admin_vassal_detail.gui
│   ├── window_appoint_tax_collector.gui
│   ├── window_artifact_details.gui
│   ├── window_artifact_helper.gui
│   ├── window_artifact_reforge.gui
│   ├── window_character_finder.gui
│   ├── window_character_lifestyle.gui
│   ├── window_council.gui
│   ├── window_council_potential_councillor.gui
│   ├── window_court.gui
│   ├── window_court_events.gui
│   ├── window_court_position_appoint.gui
│   ├── window_court_positions.gui
│   ├── window_court_types.gui
│   ├── window_create_accolade.gui
│   ├── window_culture.gui
│   ├── window_decisions.gui
│   ├── window_decisions_detail.gui
│   ├── window_diverge_culture.gui
│   ├── window_domicile.gui
│   ├── window_dynasty_house.gui
│   ├── window_dynasty_legacy.gui
│   ├── window_epidemics.gui
│   ├── window_faith_conversion.gui
│   ├── window_find_title.gui
│   ├── window_ghw.gui
│   ├── window_ghw_change_target.gui
│   ├── window_hired_troops_detail.gui
│   ├── window_hybridize_culture.gui
│   ├── window_inspirations.gui
│   ├── window_intrigue.gui
│   ├── window_intrigue_potential_faction_member.gui
│   ├── window_intrigue_potential_scheme_agent.gui
│   ├── window_inventory.gui
│   ├── window_kill_list.gui
│   ├── window_knights.gui
│   ├── window_languages.gui
│   ├── window_lease_out_baronies.gui
│   ├── window_legend_chronicle.gui
│   ├── window_levy.gui
│   ├── window_lineage.gui
│   ├── window_memories.gui
│   ├── window_my_realm.gui
│   ├── window_rally_points.gui
│   ├── window_ruler_designer.gui
│   ├── window_ruler_designer_save.gui
│   ├── window_struggle.gui
│   ├── window_succession_change_law.gui
│   ├── window_task_contract.gui
│   ├── window_title.gui
│   ├── window_title_appointment.gui
│   ├── window_title_election.gui
│   ├── window_travel_option_selection.gui
│   ├── window_war_overview.gui
│   └── window_war_results.gui
├── history/
│   ├── _characters.info
│   ├── _history.info
│   ├── _provinces.info
│   ├── artifacts/
│   ├── characters/
│   ├── cultures/
│   ├── province_mapping/
│   ├── provinces/
│   ├── struggles/
│   ├── titles/
│   └── wars/
└── localization/
    ├── english/
    ├── french/
    ├── german/
    ├── jomini/
    ├── korean/
    ├── languages.yml
    ├── polish/
    ├── russian/
    ├── simp_chinese/
    └── spanish/
```