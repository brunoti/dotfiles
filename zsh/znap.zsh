[[ -r ~/.local/znap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/.local/znap

source ~/.local/znap/znap.zsh

znap source zdharma/fast-syntax-highlighting
# znap source marlonrichert/zsh-autocomplete
znap source zsh-users/zsh-autosuggestions

# `znap source` automatically downloads and starts your plugins.
znap source hlissner/zsh-autopair
znap source ohmyzsh/ohmyzsh lib/completion.zsh
znap source ohmyzsh/ohmyzsh lib/history.zsh
znap source ohmyzsh/ohmyzsh lib/key-bindings.zsh
# znap source ohmyzsh/ohmyzsh plugins/{extract}
znap source ael-code/zsh-colored-man-pages
znap source mafredri/zsh-async

# `znap prompt` makes your prompt visible in just 15-40ms!
# znap prompt sindresorhus/pure  # replaced by oh-my-posh
