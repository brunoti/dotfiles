source ~/Git/zsh-snap/znap.zsh  # Start Znap

# `znap source` automatically downloads and starts your plugins.
znap source zdharma/fast-syntax-highlighting
znap source hlissner/zsh-autopair
znap source ohmyzsh/ohmyzsh lib/completion.zsh
znap source ohmyzsh/ohmyzsh lib/history.zsh
znap source ohmyzsh/ohmyzsh lib/key-bindings.zsh
znap source ohmyzsh/ohmyzsh plugins/{sudo,extract,yarn}
znap source ael-code/zsh-colored-man-pages
znap source mafredri/zsh-async

# `znap prompt` makes your prompt visible in just 15-40ms!
znap prompt sindresorhus/pure
