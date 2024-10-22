HOMEBREW_PREFIX="$HOME/.config/homebrew"
if [ -d "$HOMEBREW_PREFIX" ]; then
	eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
fi
