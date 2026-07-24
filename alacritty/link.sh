#!/usr/bin/env bash
set -euo pipefail

source_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
target_dir="$HOME/.config/alacritty"

mkdir -p "$target_dir/themes"
ln -sfn "$source_dir/alacritty.toml" "$target_dir/alacritty.toml"
ln -sfn "$source_dir/themes/tokyo_night_enhanced.toml" "$target_dir/themes/tokyo_night_enhanced.toml"
