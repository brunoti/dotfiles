#!/bin/bash
set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "$0")/.." && pwd -P)"

link_file() {
  local source="$1"
  local target="$2"
  local target_dir; target_dir="$(dirname "$target")"

  mkdir -p "$target_dir"

  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    return 0
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    local backup="${target}.backup"
    if [ -e "$backup" ]; then
      echo "Error: backup already exists at '$backup'"
      exit 1
    fi
    mv "$target" "$backup"
    echo "Moved existing target to '$backup'"
  fi

  ln -s "$source" "$target"
  echo "Linked '$source' -> '$target'"
}

link_file "$DOTFILES_ROOT/rmux/rmux.conf" "$HOME/.config/rmux/rmux.conf"
