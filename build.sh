#!/bin/bash

# Build script for Dede Joker mod
# Converts SVG placeholders to PNG format

echo "Building Dede Joker mod assets..."

# Check if ImageMagick is available
if ! command -v convert &> /dev/null; then
    echo "Warning: ImageMagick not found. Install with: sudo apt install imagemagick"
    echo "Skipping PNG generation from SVG..."
    exit 0
fi

# Create PNG versions from SVG placeholders
echo "Generating PNG sprites from SVG..."

# 1x resolution
convert assets/sprites/j_dede.svg assets/sprites/j_dede.png
echo "Created: assets/sprites/j_dede.png (71x95)"

# 2x resolution  
convert assets/sprites/j_dede_2x.svg assets/sprites/j_dede_2x.png
echo "Created: assets/sprites/j_dede_2x.png (142x190)"

echo "Build complete! Place your custom PNG files in assets/sprites/ to replace placeholders."