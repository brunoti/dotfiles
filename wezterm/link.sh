#!/bin/bash

# Define the source file and target location
SOURCE="$DOTFILES/wezterm/wezterm.lua"
TARGET_LOCATION="$HOME/.config/wezterm/wezterm.lua"
TARGET_DIR="$(dirname "$TARGET_LOCATION")" # Extract the directory from the target location

# Check if the source exists
if [ ! -e "$SOURCE" ]; then
  echo "Error: Source '$SOURCE' does not exist."
  exit 1
fi

# Check if the target directory exists; if not, create it
if [ ! -d "$TARGET_DIR" ]; then
  echo "Target directory '$TARGET_DIR' does not exist. Creating it..."
  mkdir -p "$TARGET_DIR"
fi

# Check if the target location already exists
if [ -e "$TARGET_LOCATION" ]; then
  echo "Warning: Target location '$TARGET_LOCATION' already exists. Replacing it..."
  rm -rf "$TARGET_LOCATION"
fi

# Create the symbolic link
ln -s "$SOURCE" "$TARGET_LOCATION"

echo "Successfully linked '$SOURCE' to '$TARGET_LOCATION'."
