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
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" --prefix="$HOMEBREW_PREFIX"

  # Adding Homebrew to PATH
  echo 'eval "$('$HOMEBREW_PREFIX'/bin/brew shellenv)"' >> "$HOME/.bash_profile"
  echo 'eval "$('$HOMEBREW_PREFIX'/bin/brew shellenv)"' >> "$HOME/.zprofile"

  # Inform the user about additional steps
  echo "=================================="
  echo "Homebrew installation complete."
  echo "To proceed, please add Homebrew to your shell configuration by running:"
  echo "source $HOME/.bash_profile"
  echo "or"
  echo "source $HOME/.zprofile"
  echo "=================================="
}

# Run the installation function
install_homebrew
