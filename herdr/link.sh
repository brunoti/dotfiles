#!/bin/bash

# Define the source file and target location
SOURCE="$DOTFILES/herdr/config/config.toml"
TARGET_LOCATION="$HOME/.config/herdr/config.toml"
TARGET_DIR="$(dirname "$TARGET_LOCATION")"

# Check if the source exists
if [ ! -e "$SOURCE" ]; then
  echo "Error: Source '$SOURCE' does not exist."
  exit 1
fi

mkdir -p "$TARGET_DIR"

# Check if the target location already exists
if [ -e "$TARGET_LOCATION" ] || [ -L "$TARGET_LOCATION" ]; then
  echo "Warning: Target location '$TARGET_LOCATION' already exists. Replacing it..."
  rm -f "$TARGET_LOCATION"
fi

# Create the symbolic link
ln -s "$SOURCE" "$TARGET_LOCATION"

echo "Successfully linked '$SOURCE' to '$TARGET_LOCATION'."
