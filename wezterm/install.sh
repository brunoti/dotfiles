#!/bin/bash

# Function to install WezTerm using Homebrew
install_wezterm() {
  # Check if WezTerm is already installed
  if command -v wezterm &> /dev/null; then
    echo "=================================="
    echo "WezTerm is already installed."
    echo "=================================="
  else
    echo "=================================="
    echo "Installing WezTerm..."
    echo "=================================="

    # Install WezTerm using Homebrew
    brew install --cask wezterm

    echo "=================================="
    echo "WezTerm installation complete."
    echo "=================================="
  fi
}

# Run the installation function
install_wezterm
