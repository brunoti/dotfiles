#!/bin/bash
set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "$0")/.." && pwd -P)"

# Derive Nushell directories from the installed binary.
NU_CONFIG_DIR="$(nu --no-config-file -c '$nu.default-config-dir')"
NU_DATA_DIR="$(nu --no-config-file -c '$nu.data-dir')"
NU_CACHE_DIR="$(nu --no-config-file -c '$nu.cache-dir')"
CARAPACE_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/carapace"


# link_file SOURCE TARGET
# Create the target directory, then create or verify an absolute symlink.
# Moves an existing non-symlink target to TARGET.backup, failing if that
# backup already exists.
link_file() {
  local source="$1"
  local target="$2"
  local target_dir; target_dir="$(dirname "$target")"

  mkdir -p "$target_dir"

  # Already the correct symlink: no-op.
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    return 0
  fi

  # Existing regular file or wrong symlink: back it up.
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

# remove_obsolete_link TARGET SOURCE
# Remove a stale symlink left by a managed file move so link_file can relink it
# without treating an existing backup as a conflict.
remove_obsolete_link() {
  local target="$1"
  local source="$2"

  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    rm "$target"
    echo "Removed obsolete symlink '$target'"
  fi
}

# generate_init TARGET COMMAND...
# Atomically write the output of COMMAND to TARGET, preserving the previous
# file on failure.
generate_init() {
  local target="$1"
  shift
  local target_dir; target_dir="$(dirname "$target")"
  mkdir -p "$target_dir"

  local tmp; tmp="$(mktemp -p "$target_dir" tmp.XXXXXXXXXX)"
  # shellcheck disable=SC2064
  trap "rm -f '$tmp'" RETURN
  if ! "$@" > "$tmp" 2>/dev/null; then
    echo "Error: failed to generate '$target'"
    return 1
  fi
  mv "$tmp" "$target"
  echo "Generated '$target'"
}

# -------------------------------------------------------------------
# Link managed config files
# -------------------------------------------------------------------

link_file "$DOTFILES_ROOT/nushell/config.nu"       "$NU_CONFIG_DIR/config.nu"
link_file "$DOTFILES_ROOT/nushell/aliases.nu"       "$NU_CONFIG_DIR/aliases.nu"

# Remove the obsolete managed workmux completion symlink if it still points at the old repo file.
if [ -L "$NU_CONFIG_DIR/completions.nu" ] && [ "$(readlink "$NU_CONFIG_DIR/completions.nu")" = "$DOTFILES_ROOT/nushell/completions.nu" ]; then
  rm "$NU_CONFIG_DIR/completions.nu"
  echo "Removed obsolete symlink '$NU_CONFIG_DIR/completions.nu'"
fi

link_file "$DOTFILES_ROOT/nushell/workmux.nu"       "$NU_CONFIG_DIR/workmux.nu"
link_file "$DOTFILES_ROOT/nushell/tokyo-night.nu"   "$NU_CONFIG_DIR/tokyo-night.nu"
link_file "$DOTFILES_ROOT/nushell/shared-env.nu"    "$NU_CONFIG_DIR/shared-env.nu"

# Migrate OMP assets moved under nushell/omp/.
remove_obsolete_link "$CARAPACE_CONFIG_DIR/specs/omp.yaml" "$DOTFILES_ROOT/nushell/omp-carapace.yaml"
remove_obsolete_link "$CARAPACE_CONFIG_DIR/bridge/zsh/.zshrc" "$DOTFILES_ROOT/nushell/carapace-bridge.zshrc"
remove_obsolete_link "$CARAPACE_CONFIG_DIR/bridge/zsh/_omp" "$DOTFILES_ROOT/nushell/omp-completion.zsh"
link_file "$DOTFILES_ROOT/nushell/omp/init.nu"      "$NU_CONFIG_DIR/omp/init.nu"
link_file "$DOTFILES_ROOT/nushell/omp/omp-carapace.yaml" "$CARAPACE_CONFIG_DIR/specs/omp.yaml"
link_file "$DOTFILES_ROOT/nushell/omp/carapace-bridge.zshrc" "$CARAPACE_CONFIG_DIR/bridge/zsh/.zshrc"
link_file "$DOTFILES_ROOT/nushell/omp/omp-completion.zsh" "$CARAPACE_CONFIG_DIR/bridge/zsh/_omp"



# Ensure local.nu exists as an untracked regular file (mode 0600).
# Never symlink, overwrite, or commit it.
if [ ! -f "$NU_CONFIG_DIR/local.nu" ]; then
  touch "$NU_CONFIG_DIR/local.nu"
  chmod 0600 "$NU_CONFIG_DIR/local.nu"
  echo "Created empty '$NU_CONFIG_DIR/local.nu' (0600)"
fi

# -------------------------------------------------------------------
# Generate version-matched integration scripts
# -------------------------------------------------------------------

# Vendor autoload: mise, starship, zoxide
mkdir -p "$NU_DATA_DIR/vendor/autoload"
generate_init "$NU_DATA_DIR/vendor/autoload/mise.nu"    mise activate nu
generate_init "$NU_DATA_DIR/vendor/autoload/starship.nu" starship init nu
generate_init "$NU_DATA_DIR/vendor/autoload/zoxide.nu"  zoxide init nushell

generate_omp_completion() {
  omp completions zsh | sed 's/_omp/_omp_generated/g'
}

# Carapace
mkdir -p "$NU_CACHE_DIR"
generate_init "$NU_CACHE_DIR/carapace.nu" carapace _carapace nushell
mkdir -p "$CARAPACE_CONFIG_DIR/bridge/zsh"
generate_init "$CARAPACE_CONFIG_DIR/bridge/zsh/_omp.generated" generate_omp_completion

# Atuin
mkdir -p "$HOME/.local/share/atuin"
generate_init "$HOME/.local/share/atuin/init.nu" atuin init nu
