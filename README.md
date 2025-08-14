# Dede Joker Balatro Mod

## Image Integration Structure

This mod includes a complete image integration system for Steamodded Balatro mods.

### Directory Structure
```
assets/
├── sprites/
│   ├── j_dede.svg          # Vector placeholder (1x)
│   ├── j_dede_2x.svg       # Vector placeholder (2x)
│   ├── j_dede.png          # Rendered sprite (71x95px)
│   └── j_dede_2x.png       # Rendered sprite (142x190px)
├── 1x/                      # 1x resolution assets
├── 2x/                      # 2x resolution assets
├── ui/                      # UI assets and atlas
└── config.lua              # Asset configuration
```

### Sprite Requirements
- **1x Resolution**: 71x95 pixels
- **2x Resolution**: 142x190 pixels
- **Format**: PNG with transparency
- **Naming**: Follow Steamodded conventions

### Integration
The mod automatically registers sprites with Steamodded using:
- `SMODS.Atlas` for sprite registration
- `atlas` parameter in joker definition
- `pos` coordinates for sprite positioning

### Replacing Placeholders
1. Create your joker artwork at the required dimensions
2. Export as PNG with transparency
3. Replace `j_dede.png` and `j_dede_2x.png` in `assets/sprites/`
4. Ensure filenames match the registered paths

### Testing
Load the mod in Balatro and verify:
- Joker appears in collection
- Sprite displays correctly
- No missing texture errors

## Features
- ✅ Steamodded header with mod metadata
- ✅ Proper sprite registration system
- ✅ 1x/2x resolution support
- ✅ Blueprint compatibility
- ✅ Configurable mult gain
- ✅ Visual feedback (juice effects)