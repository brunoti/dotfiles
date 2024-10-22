#!/bin/bash

# Function to install applications using Homebrew Cask
install_casks() {
  declare -a apps=(
    "rambox"
    "setapp"
    "zoom"
    "alacritty"
    "canva"
    "figma"
    "postman"
    "librewolf"
    "bitwarden"
    "brave-browser"
    "karabiner-elements"
    "alt-tab"
    "rectangle"
    "arc"
  )

  echo "=================================="
  echo "Installing applications via Homebrew Cask..."
  echo "=================================="
  echo "" # Empty line for separation

  for app in "${apps[@]}"; do
    echo "=================================="
    echo "Checking installation for $app..."
    echo "=================================="

    if brew list --cask | grep -q "$app"; then
      echo "$app is already installed."
    else
      echo "Installing $app..."
      brew install --cask "$app" --force
      echo "$app installation complete."
    fi
    echo "" # Empty line for separation
  done
}

# Main script execution
install_homebrew
install_casks

echo "=================================="
echo "All specified applications have been installed."
echo "=================================="
