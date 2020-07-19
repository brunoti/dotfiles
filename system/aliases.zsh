# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if $(gls &>/dev/null)
then
alias ls="gls -G --group-directories-first --color"
alias l='gls --group-directories-first --color -lah'
alias la='gls --group-directories-first --color -lAh'
alias ll='gls --group-directories-first --color -lh'
alias lsa='gls --group-directories-first --color -lah'
fi

# add pbcopy/pbpaste on Linux
if test "$(uname)" != "Darwin"
then
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
fi

alias sudo="sudo "
alias rm="trash"
alias _rm="/bin/rm"
