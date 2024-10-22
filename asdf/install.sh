#!/bin/bash

# Function to install asdf if it's not installed
install_asdf() {
  if ! command -v asdf &> /dev/null; then
    echo "=================================="
    echo "Installing ASDF..."
    echo "=================================="
    brew install coreutils curl git
    brew install asdf
  else
    echo "=================================="
    echo "ASDF is already installed."
    echo "=================================="
  fi

  echo "" # Empty line for separation
}

# Function to add and install a plugin
add_and_install_plugin() {
  local plugin="$1"
  local language="$2"
  local version="${3:-latest}"

  echo "=================================="
  echo "Installing $language..."
  echo "=================================="

  if asdf plugin list | grep -q "$plugin"; then
    echo "$plugin is already added."
  else
    echo "Adding $plugin plugin..."
    asdf plugin add "$plugin"
  fi

  echo "Installing the latest version of $language..."
  asdf install "$plugin" "$version"

  echo "Setting $language →  $version as the default version..."
  asdf global "$plugin" "$version"

  echo "" # Empty line for separation
}

# Function to install the latest LTS version of Node.js
install_nodejs_lts() {
  echo "=================================="
  echo "Installing Node.js LTS..."
  echo "=================================="

  if asdf plugin list | grep -q "nodejs"; then
    echo "Node.js plugin is already added."
  else
    echo "Adding Node.js plugin..."
    asdf plugin add nodejs
  fi

  lts_version=$(asdf nodejs resolve lts --latest-available)
  echo "Installing the latest LTS version of Node.js ($lts_version)..."
  asdf install nodejs "$lts_version"

  echo "Setting the LTS version of Node.js as the default..."
  asdf global nodejs "$lts_version"

  echo "" # Empty line for separation
}

# Main script execution
install_asdf
install_nodejs_lts
add_and_install_plugin "erlang" "Erlang"
add_and_install_plugin "rebar" "Rebar"
add_and_install_plugin "elixir" "Elixir"
add_and_install_plugin "gleam" "Gleam"
add_and_install_plugin "bun" "Bun"
add_and_install_plugin "rust" "Rust"
add_and_install_plugin "python" "Python" "3.13.0"

echo "=================================="
echo "All specified languages have been installed and set as default."
echo "=================================="
