use std/util "path add"

let home = $nu.home-dir
let brew_prefix = ($home | path join ".config" "homebrew")

$env.HOMEBREW_PREFIX = $brew_prefix
$env.HOMEBREW_CELLAR = ($brew_prefix | path join "Cellar")
$env.HOMEBREW_REPOSITORY = $brew_prefix
path add ($brew_prefix | path join "bin") ($brew_prefix | path join "sbin")

let ghostty_bin = ($env.GHOSTTY_BIN_DIR? | default "")
if not ($ghostty_bin | is-empty) {
    path add $ghostty_bin
}

path add --append ...[
    ($home | path join ".local" "bin")
    ($home | path join "go" "bin")
    ($home | path join ".tmux" "plugins" "tmux-open-nvim" "scripts")
    ($home | path join ".dotnet" "tools")
]

$env.PNPM_HOME = ($home | path join ".local" "share" "pnpm" "store")
path add $env.PNPM_HOME

path add "/opt/local/bin" "/opt/local/sbin"

$env.BUN_INSTALL = ($home | path join ".bun")
path add ...[
    ($home | path join ".cache" ".bun" "bin")
    ($env.BUN_INSTALL | path join "bin")
]

let brew_info = ($brew_prefix | path join "share" "info")
let existing_info = (
    $env.INFOPATH?
    | default ""
    | split row (char esep)
    | where {|entry| not ($entry | is-empty) }
)
$env.INFOPATH = (
    $existing_info
    | prepend $brew_info
    | uniq
    | str join (char esep)
)

$env.TERM = "xterm-256color"
$env.DISABLE_AUTO_TITLE = "true"
$env.ONE_MCP_CONFIG_DIR = ($home | path join ".config" "1mcp")
$env.OMNIROUTE_BASE_URL = "https://omniroute.bop.lat"
$env.AGENTMEMORY_URL = "http://localhost:3111"
$env.NVIM_APPNAME = 'nvim2'
