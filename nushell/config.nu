source ($nu.default-config-dir | path join "shared-env.nu")
source ($nu.default-config-dir | path join "local.nu")
source ($nu.default-config-dir | path join "tokyo-night.nu")

$env.config.show_banner = false
$env.config.buffer_editor = "nvim"
$env.config.edit_mode = "vi"
$env.config.cursor_shape.vi_insert = "line"
$env.config.cursor_shape.vi_normal = "block"

$env.config.history.file_format = "sqlite"
$env.config.history.max_size = 100_000
$env.config.history.sync_on_enter = true
$env.config.history.isolation = false

$env.config.completions.case_sensitive = false
$env.config.completions.quick = true
$env.config.completions.partial = true
$env.config.completions.algorithm = "fuzzy"
$env.config.completions.use_ls_colors = true

$env.config.table.mode = "rounded"
$env.config.table.index_mode = "auto"
$env.config.table.show_empty = true
$env.config.table.padding = { left: 1, right: 1 }

$env.config.color_config = (tokyo-night)
$env.CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense"

source ($nu.cache-dir | path join "carapace.nu")
source ~/.local/share/atuin/init.nu
source ($nu.default-config-dir | path join "aliases.nu")
source ($nu.default-config-dir | path join "commands.nu")
