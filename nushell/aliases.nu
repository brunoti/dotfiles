alias cls = clear
alias vim = nvim
alias vi = nvim
alias rm = trash
alias _rm = ^/bin/rm
alias l = ls -la
alias la = ls -la
alias ll = ls -l
alias lsa = ls -la

alias ".." = cd ../
alias "../" = cd ../
alias "...." = cd ../../
alias "....." = cd ../../../
alias cat = bat
alias b = bun
alias bx = bunx
alias p = pnpm
alias px = pnpx
alias sxng = bun ~/Projects/bopstack/searxng-cli/src/index.ts

alias g = git
alias ga = git add
alias gaa = git add --all
alias gapa = git add --patch
alias gau = git add --update
alias gb = git branch
alias gba = git branch -a
alias gbd = git branch -d
alias gbD = git branch -D
alias gbr = git branch --remote
alias gc = git commit -v
alias gca = git commit -v -a
alias gcmsg = git commit -m
alias gcam = git commit -a -m
alias gcl = git clone --recurse-submodules
alias gco = git checkout
alias gcb = git checkout -b
alias gsw = git switch
alias gswc = git switch -c
alias gd = git diff
alias gdca = git diff --cached
alias gds = git diff --staged
alias gdw = git diff --word-diff
alias gf = git fetch
alias gfa = git fetch --all --prune
alias gl = git pull
alias gp = git push
alias gpf = git push --force-with-lease
alias gpr = git pull --rebase
alias gup = git pull --rebase
alias gupa = git pull --rebase --autostash
alias glg = git log --stat
alias glgp = git log --stat -p
alias glgg = git log --graph
alias glo = git log --oneline --decorate
alias glog = git log --oneline --decorate --graph
alias gloga = git log --oneline --decorate --graph --all
alias gm = git merge
alias gma = git merge --abort
alias gmf = git merge --no-ff
alias grb = git rebase
alias grba = git rebase --abort
alias grbc = git rebase --continue
alias grbi = git rebase -i
alias grbs = git rebase --skip
alias grh = git reset
alias grhh = git reset --hard
alias grs = git restore
alias grst = git restore --staged
alias gr = git remote
alias gra = git remote add
alias grv = git remote -v
alias gst = git status
alias gsb = git status -sb
alias gss = git status -s
alias gsta = git stash push
alias gstaa = git stash apply
alias gstc = git stash clear
alias gstd = git stash drop
alias gstl = git stash list
alias gstp = git stash pop
alias gcp = git cherry-pick
alias gcpa = git cherry-pick --abort
alias gcpc = git cherry-pick --continue

alias d = docker
alias dc = docker-compose
alias dcu = docker-compose up
alias ios = open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app
alias watchos = open "/Applications/Xcode.app/Contents/Developer/Applications/Simulator (Watch).app"

def "reload!" [] {
    exec nu
}

def remove-from-quarentine [path: path] {
    sudo xattr -r -d com.apple.quarantine $path
}

def --env grt [] {
    cd (git rev-parse --show-toplevel | str trim)
}

def --env root [] {
    grt
}

def pubkey [] {
    let keys = glob ($nu.home-dir | path join ".ssh" "id_*.pub") | sort
    if ($keys | is-empty) {
        error make { msg: "No public SSH key found" }
    }
    open --raw ($keys | first) | pbcopy
    print "=> Public key copied to pasteboard."
}

def to-snake-case [value: string] { npx case-cli $value --case=snake }
def to-pascal-case [value: string] { npx case-cli $value --case=pascal }
def to-camel-case [value: string] { npx case-cli $value --case=camel }
def to-kebab-case [value: string] { npx case-cli $value --case=kebab }
def to-header-case [value: string] { npx case-cli $value --case=header }
def to-constant-case [value: string] { npx case-cli $value --case=constant }
def to-upper-case [value: string] { npx case-cli $value --case=upper }
def to-lower-case [value: string] { npx case-cli $value --case=lower }
def to-capital-case [value: string] { npx case-cli $value --case=capital }
def to-title-case [value: string] { npx case-cli $value --case=title }
def to-sentence-case [value: string] { npx case-cli $value --case=sentence }
