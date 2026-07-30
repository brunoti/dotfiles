# Set the bridge order before loading Carapace's Nushell completer.
$env.CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense"
source ($nu.cache-dir | path join "carapace.nu")
