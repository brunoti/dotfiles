#!/bin/bash

# Function to install tmux if it's not installed
install_tmux() {
  if ! command -v tmux &> /dev/null; then
    echo "=================================="
    echo "Installing tmux..."
    echo "=================================="
    echo ""
    brew install tmux
    echo ""
    echo "=================================="
    echo "tmux installation complete."
    echo "=================================="
    echo ""
  else
    echo "=================================="
    echo "tmux is already installed."
    echo "=================================="
    echo "" # Empty line for separation
  fi
}

# Main script execution
install_tmux
