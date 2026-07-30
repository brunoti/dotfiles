# Keep the bridge's fpath self-contained so unrelated shell completions cannot break compinit.
fpath=(
    "${CARAPACE_BRIDGE_CONFIG_HOME:-$HOME/.config}/carapace/bridge/zsh"
    /usr/share/zsh/site-functions
    /usr/share/zsh/5.9/functions
)
unfunction _omp 2>/dev/null
autoload -Uz _omp
compdef _omp omp
