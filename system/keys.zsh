# Pipe my public key to my clipboard.
alias pubkey="ls ~/.ssh/id_*.pub 2>/dev/null | head -1 | xargs cat | pbcopy && echo '=> Public key copied to pasteboard.'"
