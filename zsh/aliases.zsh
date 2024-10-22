alias reload!='. ~/.zshrc'
alias cls='clear' # Good 'ol Clear Screen command
alias remove-from-quarentine='sudo xattr -r -d com.apple.quarantine'

function to-snake-case () { case-cli $1 --case=snake }
function to-pascal-case () { case-cli $1 --case=pascal }
function to-camel-case () { case-cli $1 --case=camel }
function to-kebab-case () { case-cli $1 --case=kebab }
function to-header-case () { case-cli $1 --case=header }
function to-constant-case () { case-cli $1 --case=constant }
function to-upper-case () { case-cli $1 --case=upper }
function to-lower-case () { case-cli $1 --case=lower }
function to-capital-case () { case-cli $1 --case=capital }
function to-title-case () { case-cli $1 --case=title }
function to-sentence-case () { case-cli $1 --case=sentence }
function to-sentence-case () { case-cli $1 --case=sentence }
