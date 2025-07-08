#!/usr/bin/env zsh
# ZSH completions

# Git worktree completion
_git-worktree() {
    local curcontext="$curcontext" state line
    typeset -A opt_args

    _arguments -C \
        '1: :->command' \
        '*:: :->option-or-argument'

    case $state in
        (command)
            local -a subcommands
            subcommands=(
                'add:Create a new working tree'
                'list:List details of each working tree'
                'lock:Lock a working tree to prevent automatic removal'
                'move:Move a working tree to a new location'
                'prune:Prune working tree information'
                'remove:Remove a working tree'
                'repair:Repair working tree administrative files'
                'unlock:Unlock a working tree'
            )
            _describe -t commands 'git worktree' subcommands
            ;;
        (option-or-argument)
            case $line[1] in
                (add)
                    _arguments \
                        '(-f --force)'{-f,--force}'[checkout even if already checked out in other worktree]' \
                        '(-B)-b[create a new branch]:branch name:__git_branch_names' \
                        '(-b)-B[create or reset a branch]:branch name:__git_branch_names' \
                        '(-d --detach)'{-d,--detach}'[detach HEAD at named commit]' \
                        '--no-checkout[suppress checkout]' \
                        '--guess-remote[guess remote tracking branch]' \
                        '--no-guess-remote[do not guess remote tracking branch]' \
                        '--track[set up tracking mode]:tracking mode:(direct inherit)' \
                        '--no-track[do not set up tracking]' \
                        '--lock[lock working tree after creation]' \
                        '--reason[reason for locking]:reason:' \
                        '(-q --quiet)'{-q,--quiet}'[suppress feedback messages]' \
                        ':path:_directories' \
                        '::commit-ish:__git_commits'
                    ;;
                (list)
                    _arguments \
                        '--porcelain[machine-readable output]' \
                        '--verbose[show more information]' \
                        '-z[terminate entries with NUL]' \
                        '--expire[add prunable annotation]:time:'
                    ;;
                (lock)
                    _arguments \
                        '--reason[reason for locking]:reason:' \
                        ':worktree:__git_worktrees'
                    ;;
                (move)
                    _arguments \
                        '(-f --force)'{-f,--force}'[force move even if worktree is dirty]' \
                        ':worktree:__git_worktrees' \
                        ':new-path:_directories'
                    ;;
                (prune)
                    _arguments \
                        '(-n --dry-run)'{-n,--dry-run}'[do not remove, show only]' \
                        '(-v --verbose)'{-v,--verbose}'[report pruned working trees]' \
                        '--expire[expire working trees older than time]:time:'
                    ;;
                (remove)
                    _arguments \
                        '(-f --force)'{-f,--force}'[remove even with modifications]' \
                        ':worktree:__git_worktrees'
                    ;;
                (unlock)
                    _arguments \
                        ':worktree:__git_worktrees'
                    ;;
            esac
            ;;
    esac
}