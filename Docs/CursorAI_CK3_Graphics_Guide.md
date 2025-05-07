# Crusader Kings 3 Graphics Modding Guide for Cursor AI

This guide covers graphics-related modding for Crusader Kings 3 to help Cursor AI assist with visual assets creation and implementation.

## Graphics Directory Structure

The `gfx/` directory contains all visual assets used in CK3:

- **FX/** - Special effects and shaders
- **coat_of_arms/** - Heraldry assets and templates
- **compound_nodes/** - Complex graphical elements
- **court_scene/** - 3D assets for royal court
- **cursors/** - Mouse cursor graphics
- **fonts/** - Font files and definitions
- **interface/** - UI graphics and icons
- **lines/** - Line graphics and patterns
- **map/** - Map textures and terrain graphics
- **models/** - 3D character and object models
- **particles/** - Particle effect definitions
- **portraits/** - Character portrait assets
- **schematics/** - Technical drawings and layouts
- **skins/** - Character skin textures

## File Formats and Standards

### Texture Files
- **Extension**: `.dds`
- **Format**:
  - With transparency: BC3/DXT5
  - Without transparency: BC1/DXT1
- **Common Sizes**: 32x32, 64x64, 128x128, 256x256, 512x512, 1024x1024

### 3D Models
- **Models**: `.mesh` files
- **Animations**: `.anim` files
- **Particles**: `.particle` files

### Fonts
- `.fnt` and `.ttf` formats
- Font definitions in `fonts/*.font` files

### Shaders
- `.shader` files for custom visual effects

## Naming Conventions

Files should follow these naming patterns:
- Use lowercase for filenames
- Use underscores for spaces
- Include category prefix (e.g., "gui_", "map_", "portrait_")
- Include size suffix for textures (e.g., "_32", "_64", "_128")
- Include state for UI elements (e.g., "_normal", "_hover", "_pressed")

Examples:
- `gui_decision_icon_forge_artifact_64.dds`
- `portrait_trait_brave_32.dds`
- `map_terrain_plains_1024.dds`

## UI Elements and Interface Modding

### Interface Directory
The most commonly modified directory is `gfx/interface/` which contains UI elements:
- **backgrounds/** - Window and panel backgrounds
- **icons/** - Game icons (traits, decisions, etc.)
- **illustrations/** - Larger art pieces and event images
- **window_widgets/** - Buttons, scrollbars, and other controls

### UI States for Interactive Elements
Interactive elements typically need multiple states:
- `_normal` - Default state
- `_hover` - Mouse hover state
- `_pressed` - Clicked state
- `_disabled` - Unavailable state
- `_selected` - Selected/active state

## Portrait System

CK3's portrait system allows customization of character appearances:

### Portrait Assets
- **accessories/** - Wearable items (crowns, jewelry)
- **clothes/** - Character clothing
- **hair/** - Hairstyles
- **beards/** - Facial hair
- **headgear/** - Helmets, hats, veils

### DNA System
Character appearance is controlled through:
- `common/genes/` - Defines genetic characteristics
- `common/dna_data/` - Preset DNA configurations

## Event Graphics

### Event Windows
- `gfx/interface/event_windows/` - Main event window templates
- `gfx/interface/illustrations/events/` - Event illustrations

### Event Backgrounds
- Defined in `common/event_backgrounds/`
- Images stored in `gfx/interface/illustrations/events/backgrounds/`

## Implementation Process

### Adding a New Icon
1. Create a `.dds` file in appropriate format and size
2. Place it in the correct subdirectory of `gfx/interface/`
3. Reference it in UI files in `gui/` directory

### Adding a New Event Illustration
1. Create illustration as `.dds` file
2. Place in `gfx/interface/illustrations/events/`
3. Reference in event definition:
```
theme = {
    background = "event_bg_council"
    illustration = "event_illustration_my_new_illustration"
}
```

### Adding a New Portrait Accessory
1. Create model files for all ethnicities
2. Place in appropriate `gfx/portraits/accessories/` subdirectory
3. Define it in `common/portrait_accessories/`

## Best Practices

1. **Match Game Style**: Follow the game's art style for consistency
2. **Optimize Textures**: Use appropriate compression and resolution
3. **Test with Different Ethnicities**: Ensure assets work with all character types
4. **Use Templates**: Start from existing assets to match style and format
5. **Check Different UI Scales**: Test at multiple resolution settings

## Tools for Graphics Modding

- **DDS Conversion**: Tools like GIMP with DDS plugin or Nvidia Texture Tools
- **3D Modeling**: Blender with PDX-compatible exporters
- **Graphics Debugging**: Use the game's debug mode to check texture loading

## Common Errors and Solutions

- **Missing Textures**: Shown as purple checkerboard - check file path and format
- **Stretched UI**: Incorrect image dimensions - adjust to expected size
- **Corrupted Models**: Issues with file format - check export settings

## Related Game Files

Graphics references are found in:
- `gui/*.gui` - User interface definitions
- `common/portrait_accessories/*.txt` - Portrait accessory definitions
- `common/coat_of_arms/coat_of_arms/*.txt` - Coat of arms patterns
- `common/genes/*.txt` - Character appearance genes 