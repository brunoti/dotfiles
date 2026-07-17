#!/bin/bash

# Prerequisite: python3 for the one-time .zsh_shared migration helper.
if ! command -v python3 &> /dev/null; then
  echo "=================================="
  echo "Error: python3 is required."
  echo "Install Python 3 before running this installer."
  echo "  brew install python3"
  echo "=================================="
  exit 1
fi

# install_formula FORMULA BINARY
# Install a Homebrew formula only when the binary is not found.
install_formula() {
  local formula="$1"
  local binary="$2"

  if command -v "$binary" &> /dev/null; then
    echo "=================================="
    echo "$binary is already installed."
    echo "=================================="
    echo ""
  else
    echo "=================================="
    echo "Installing $binary..."
    echo "=================================="
    echo ""
    brew install "$formula"
    echo ""
    echo "=================================="
    echo "$binary installation complete."
    echo "=================================="
    echo ""
  fi
}

# Main script execution
install_formula nushell nu
install_formula mise mise
install_formula starship starship
install_formula atuin atuin
install_formula zoxide zoxide
install_formula carapace carapace
