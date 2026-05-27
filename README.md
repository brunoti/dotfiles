# bruno does dotfiles

Your dotfiles are how you personalize your system. These are mine.

## topical

Everything's organized around topic areas. Add a new area — say, "Java" — by
creating a `java` directory with `.zsh` files (auto-loaded into shell),
`*.symlink` files (symlinked to `$HOME` by `script/bootstrap`), and
`install.sh` (run by `script/install`).

## components

- **bin/**: Scripts added to `$PATH`.
- **topic/\*.zsh**: Auto-loaded into shell.
- **topic/path.zsh**: Loaded first — sets up `$PATH`.
- **topic/completion.zsh**: Loaded last — autocomplete setup.
- **topic/install.sh**: Executed by `script/install`.
- **topic/\*.symlink**: Symlinked into `$HOME` by `script/bootstrap`.

## what's inside

| Area     | Tools |
|----------|-------|
| Shell    | Zsh with znap (fast-syntax-highlighting, autosuggestions, autopair, autocomplete) |
| Editor   | Neovim (LazyVim-style) with LSP (vtsls, biome, lua_ls), blink.cmp, CodeCompanion |
| Terminal | WezTerm (Tokyo Night) |
| TMUX     | tmux with TPM, vim-style nav, floax, resurrect/continuum, Tokyo Night theme |
| Git      | Delta diff, lazygit integration, rerere, fsmonitor |
| macOS    | Homebrew, sane defaults, casks |
| System   | asdf, direnv, aliases, env vars |

## install

```sh
git clone https://github.com/brunoti/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
```

Symlinks `.symlink` files into `$HOME`. Run `dot` to install dependencies,
set macOS defaults, and keep things fresh.

## thanks

Forked from [Ryan Bates](http://github.com/holman)' excellent
[dotfiles](http://github.com/holman/dotfiles).
