alias reload!='. ~/.zshrc'
alias cls='clear' # Good 'ol Clear Screen command
alias remove-from-quarentine='sudo xattr -r -d com.apple.quarantine'

function to-snake-case () { npx case-cli $1 --case=snake }
function to-pascal-case () { npx case-cli $1 --case=pascal }
function to-camel-case () { npx case-cli $1 --case=camel }
function to-kebab-case () { npx case-cli $1 --case=kebab }
function to-header-case () { npx case-cli $1 --case=header }
function to-constant-case () { npx case-cli $1 --case=constant }
function to-upper-case () { npx case-cli $1 --case=upper }
function to-lower-case () { npx case-cli $1 --case=lower }
function to-capital-case () { npx case-cli $1 --case=capital }
function to-title-case () { npx case-cli $1 --case=title }
function to-sentence-case () { npx case-cli $1 --case=sentence }
