#!/bin/bash

# Define the source file and target location
SOURCE="$DOTFILES/nvim/config"
TARGET_LOCATION="$HOME/.config/nvim"


# Check if the source exists
if [ ! -e "$SOURCE" ]; then
  echo "Error: Source '$SOURCE' does not exist."
  exit 1
fi

# Check if the target location already exists
if [ -e "$TARGET_LOCATION" ]; then
  echo "Warning: Target location '$TARGET_LOCATION' already exists. Replacing it..."
  rm -rf "$TARGET_LOCATION"
fi

# Create the symbolic link
ln -s "$SOURCE" "$TARGET_LOCATION"

echo "Successfully linked '$SOURCE' to '$TARGET_LOCATION'."
