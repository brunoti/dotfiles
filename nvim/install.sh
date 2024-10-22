if ! command -v nvim &> /dev/null; then
  echo "=================================="
  echo "Installing NEOVIM..."
  echo "=================================="
  brew install nvim
else
  echo "=================================="
  echo "NEOVIM is already installed."
  echo "=================================="
fi

echo "" # Empty line for separation
