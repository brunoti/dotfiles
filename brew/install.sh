#!/bin/bash

# Set the installation directory
HOMEBREW_PREFIX="$HOME/.config/homebrew"

# Function to install Homebrew
install_homebrew() {
  # Check if Homebrew is already installed
  if [ -d "$HOMEBREW_PREFIX" ]; then
    echo "=================================="
    echo "Homebrew is already installed in $HOMEBREW_PREFIX."
    echo "=================================="
    exit 0
  fi

  echo "=================================="
  echo "Installing Homebrew in $HOMEBREW_PREFIX..."
  echo "=================================="

  # Run the Homebrew installation script
  mkdir -p "$HOMEBREW_PREFIX"
  /bin/bash -c git clone https://github.com/Homebrew/brew "$HOMEBREW_PREFIX"
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
  brew update --force --quiet
  sudo chmod -R go-w "$(brew --prefix)/share/zsh"
}

# Run the installation function
install_homebrew
