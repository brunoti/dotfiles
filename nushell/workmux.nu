# Native Nushell completions for workmux.
# Keep dynamic values best-effort so completion remains available outside a Git worktree.

def "nu-complete workmux commands" [] {
    [
        { value: add description: "Create a worktree and tmux window" }
        { value: remove description: "Remove a worktree without merging" }
        { value: rm description: "Alias for remove" }
        { value: rename description: "Rename a worktree and tmux target" }
        { value: merge description: "Merge a branch and clean up" }
        { value: rebase description: "Rebase a worktree branch" }
        { value: open description: "Open an existing worktree" }
        { value: close description: "Close a worktree's tmux window" }
        { value: resurrect description: "Restore worktree windows after a crash" }
        { value: dashboard description: "Show the workmux dashboard" }
        { value: sidebar description: "Toggle the tmux agent sidebar" }
        { value: list description: "List all worktrees" }
        { value: ls description: "Alias for list" }
        { value: path description: "Print a worktree filesystem path" }
        { value: status description: "Query agent status" }
        { value: init description: "Generate an example configuration" }
        { value: setup description: "Install hooks and skills" }
        { value: uninstall description: "Remove hooks, skills, and state" }
        { value: config description: "Manage global configuration" }
        { value: sandbox description: "Manage sandbox settings" }
        { value: sync-files description: "Re-apply worktree file operations" }
        { value: claude description: "Manage Claude Code integration" }
        { value: send description: "Send a prompt to an agent" }
        { value: capture description: "Capture terminal output from an agent" }
        { value: wait description: "Wait for an agent status" }
        { value: run description: "Run a command in a worktree" }
        { value: reap-agents description: "Exit stale agent processes" }
        { value: docs description: "Show detailed documentation" }
        { value: changelog description: "Show the changelog" }
        { value: update description: "Update workmux" }
        { value: completions description: "Generate shell completions" }
        { value: help description: "Print help for a command" }
    ]
}

def "nu-complete workmux shells" [] {
    [
        { value: bash description: "Bash completion script" }
        { value: elvish description: "Elvish completion script" }
        { value: fish description: "Fish completion script" }
        { value: powershell description: "PowerShell completion script" }
        { value: zsh description: "Zsh completion script" }
    ]
}

def "nu-complete workmux modes" [] {
    [
        { value: window description: "Use a tmux window" }
        { value: session description: "Use a dedicated tmux session" }
    ]
}

def "nu-complete workmux dashboard tabs" [] {
    [
        { value: agents description: "Show agents" }
        { value: worktrees description: "Show worktrees" }
    ]
}

def "nu-complete workmux sidebar filters" [] {
    [
        { value: none description: "Do not filter" }
        { value: all description: "Show all projects" }
        { value: session description: "Show the current session" }
        { value: project description: "Show the current project" }
    ]
}

def "nu-complete workmux worktrees" [] {
    try {
        ^workmux list --json
        | from json
        | each {|worktree|
            {
                value: $worktree.handle
                description: ($worktree.branch + "  " + $worktree.path)
            }
        }
        | sort-by value
    } catch {
        []
    }
}

def "nu-complete workmux branches" [] {
    try {
        ^git branch --all --format="%(refname:short)"
        | lines
        | str trim
        | where {|branch| $branch != ""}
        | uniq
        | sort
    } catch {
        []
    }
}

def "nu-complete workmux targets" [] {
    let worktrees = (nu-complete workmux worktrees | each {|entry| $entry.value })
    let branches = (nu-complete workmux branches)
    $worktrees ++ $branches | uniq | sort
}

export extern workmux [
    command?: string@"nu-complete workmux commands"
    -h
    --help
    -V
    --version
]

export extern "workmux add" [
    branch_name?: string@"nu-complete workmux branches"
    --pr: int
    -A
    --auto-name
    --base: string@"nu-complete workmux branches"
    --name: string
    --target-name: string
    --parent-session: string
    -p: string
    --prompt: string
    -P: path
    --prompt-file: path
    -e
    --prompt-editor
    --prompt-file-only
    -H
    --no-hooks
    -F
    --no-file-ops
    -C
    --no-pane-cmds
    -b
    --background
    -o
    --open-if-exists
    -S
    --sandbox
    -w
    --with-changes
    --patch
    -u
    --include-untracked
    -a: string
    --agent: string
    -n: int
    --count: int
    --foreach: string
    --branch-template: string
    --max-concurrent: int
    -l: string
    --layout: string
    --mode: string@"nu-complete workmux modes"
    -s
    --session
    --config: path
    -W
    --wait
    -h
    --help
]

export extern "workmux remove" [
    ...names: string@"nu-complete workmux targets"
    --gone
    --all
    -f
    --force
    -k
    --keep-branch
    -h
    --help
]

export extern "workmux rm" [
    ...names: string@"nu-complete workmux targets"
    --gone
    --all
    -f
    --force
    -k
    --keep-branch
    -h
    --help
]

export extern "workmux rename" [
    ...names: string@"nu-complete workmux targets"
    -b
    --branch
    -h
    --help
]

export extern "workmux merge" [
    name?: string@"nu-complete workmux targets"
    --into: string@"nu-complete workmux branches"
    --ignore-uncommitted
    --rebase
    --squash
    -k
    --keep
    --cleanup
    -n
    --no-verify
    --no-hooks
    --notification
    -h
    --help
]

export extern "workmux rebase" [
    name?: string@"nu-complete workmux targets"
    -h
    --help
]

export extern "workmux open" [
    ...names: string@"nu-complete workmux worktrees"
    --run-hooks
    --force-files
    -n
    --new
    --mode: string@"nu-complete workmux modes"
    -s
    --session
    --target-name: string
    --parent-session: string
    -c
    --continue
    -p: string
    --prompt: string
    -P: path
    --prompt-file: path
    -e
    --prompt-editor
    --prompt-file-only
    --config: path
    -h
    --help
]

export extern "workmux close" [
    name?: string@"nu-complete workmux worktrees"
    -h
    --help
]

export extern "workmux resurrect" [
    --dry-run
    -h
    --help
]

export extern "workmux dashboard" [
    -P: int
    --preview-size: int
    -t: string@"nu-complete workmux dashboard tabs"
    --tab: string@"nu-complete workmux dashboard tabs"
    -d
    --diff
    -s
    --session
    -h
    --help
]

export extern "workmux sidebar" [
    --position: string@"nu-complete workmux sidebar positions"
    -s
    --session
    -h
    --help
]

def "nu-complete workmux sidebar positions" [] {
    [
        { value: left description: "Place sidebar on the left" }
        { value: top description: "Place sidebar at the top" }
    ]
}

export extern "workmux sidebar next" [-h --help]
export extern "workmux sidebar prev" [-h --help]
export extern "workmux sidebar jump" [index: int -h --help]
export extern "workmux sidebar filter" [mode?: string@"nu-complete workmux sidebar filters" -h --help]
export extern "workmux sidebar help" [-h --help]

export extern "workmux list" [
    ...filter: string@"nu-complete workmux targets"
    --pr
    --json
    -h
    --help
]

export extern "workmux ls" [
    ...filter: string@"nu-complete workmux targets"
    --pr
    --json
    -h
    --help
]

export extern "workmux path" [
    name: string@"nu-complete workmux worktrees"
    -h
    --help
]

export extern "workmux status" [
    ...worktrees: string@"nu-complete workmux worktrees"
    --json
    --git
    -h
    --help
]

export extern "workmux init" [-h --help]
export extern "workmux setup" [--hooks --skills -h --help]

export extern "workmux config help" [-h --help]
export extern "workmux config" [-h --help]
export extern "workmux config edit" [-h --help]
export extern "workmux config path" [-h --help]
export extern "workmux config reference" [-h --help]

export extern "workmux sandbox" [-h --help]
export extern "workmux sandbox build" [-h --help]
export extern "workmux sandbox pull" [-h --help]
export extern "workmux sandbox init-dockerfile" [--force -h --help]
export extern "workmux sandbox stop" [name?: string --all -y --yes -h --help]
export extern "workmux sandbox prune" [-f --force -h --help]
export extern "workmux sandbox help" [-h --help]
export extern "workmux sandbox agent" [...command: string -h --help]
export extern "workmux sandbox shell" [...command: string -e --exec -h --help]
export extern "workmux sandbox install-dev" [--skip-build --release -h --help]

export extern "workmux sync-files" [--all -h --help]

export extern "workmux claude help" [-h --help]
export extern "workmux claude" [-h --help]
export extern "workmux claude prune" [-h --help]

export extern "workmux send" [
    name: string@"nu-complete workmux worktrees"
    text?: string
    -f: path
    --file: path
    -h
    --help
]

export extern "workmux capture" [
    name: string@"nu-complete workmux worktrees"
    -n: int
    --lines: int
    -h
    --help
]

export extern "workmux wait" [
    ...worktrees: string@"nu-complete workmux worktrees"
    --status: string
    --timeout: int
    --any
    -h
    --help
]

export extern "workmux run" [
    name: string@"nu-complete workmux worktrees"
    ...command: string
    --timeout: int
    -b
    --background
    --keep
    -h
    --help
]

export extern "workmux reap-agents" [
    --hours: int
    -f
    --force
    -h
    --help
]

export extern "workmux docs" [-h --help]
export extern "workmux uninstall" [--dry-run -h --help]
export extern "workmux changelog" [-h --help]
export extern "workmux update" [-h --help]
export extern "workmux completions" [shell: string@"nu-complete workmux shells" -h --help]
export extern "workmux help" [command?: string@"nu-complete workmux commands" -h --help]


# @antfu/ni v30.3.0 exposes one command family: ni, nr, nlx, nup, nun, nci, na, nd.
# Keep the broad arguments permissive while offering the documented global options.
def "nu-complete ni options" [] {
    [
        { value: "-C" description: "Change directory before running the command" }
        { value: "-i" description: "Interactive package management" }
        { value: "-v" description: "Show the ni version" }
        { value: "--version" description: "Show the ni version" }
        { value: "--agent" description: "Print the detected package-manager agent" }
        { value: "-h" description: "Show help" }
        { value: "--help" description: "Show help" }
        { value: "?" description: "Print the resolved package-manager command" }
    ]
}

def "nu-complete ni scripts" [] {
    try {
        ^nr --completion ""
        | lines
        | where {|script| ($script | str trim) != ""}
        | each {|script|
            {
                value: ($script | str trim)
                description: "package.json script"
            }
        }
    } catch {
        []
    }
}

def "nu-complete ni na commands" [] {
    [
        { value: "run" description: "Run a package script with the detected agent" }
    ] ++ (nu-complete ni options)
}

export extern ni [
    argument?: string@"nu-complete ni options"
    ...arguments: string
]

export extern nr [
    script?: string@"nu-complete ni scripts"
    ...arguments: string
]

export extern nlx [
    argument?: string@"nu-complete ni options"
    ...arguments: string
]

export extern nup [
    argument?: string@"nu-complete ni options"
    ...arguments: string
]

export extern nun [
    argument?: string@"nu-complete ni options"
    ...arguments: string
]

export extern nci [
    argument?: string@"nu-complete ni options"
    ...arguments: string
]

export extern na [
    command?: string@"nu-complete ni na commands"
    script?: string@"nu-complete ni scripts"
    ...arguments: string
]

export extern nd [
    argument?: string@"nu-complete ni options"
    ...arguments: string
]

def "nu-complete package scripts for manager" [spans: list<string>] {
    let command = ($spans | first)
    let manager = (match $command {
        "p" => "pnpm"
        "b" => "bun"
        _ => $command
    })

    if $manager not-in ["npm", "pnpm", "bun"] {
        return { handled: false completions: [] }
    }

    let args = ($spans | skip 1)
    let run = (
        $args
        | enumerate
        | where {|entry| $entry.item == "run"}
        | get index
        | first
    )

    if $run == null {
        return { handled: false completions: [] }
    }

    let script_args = ($args | skip ($run + 1))
    if ($script_args | length) > 1 {
        return { handled: false completions: [] }
    }

    let candidate = ($script_args | first | default "" | str trim)
    let completions = (try {
        ^nr --completion $candidate
        | lines
        | where {|script| ($script | str trim) != ""}
        | each {|script|
            {
                value: ($script | str trim)
                description: "package.json script"
            }
        }
    } catch {
        []
    })

    { handled: true completions: $completions }
}

let _carapace_completer = ($env.config.completions.external | get completer?)
if $_carapace_completer != null {
    $env.config.completions.external.completer = {|spans|
        let result = (nu-complete package scripts for manager $spans)
        if $result.handled {
            $result.completions
        } else {
            do $_carapace_completer $spans
        }
    }
}
