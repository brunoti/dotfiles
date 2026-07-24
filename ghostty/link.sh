#!/usr/bin/env bash
set -euo pipefail

source_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
target_dir="$HOME/.config/ghostty"

mkdir -p "$target_dir"
ln -sfn "$source_dir/config" "$target_dir/config"
