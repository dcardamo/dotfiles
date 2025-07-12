#!/usr/bin/env zsh
# ZSH completions

# wt command completion
_wt() {
    local curcontext="$curcontext" state line
    typeset -A opt_args
    
    local projects_dir="$HOME/git"
    local worktrees_dir="$HOME/git/wt"
    
    # Check if we're dealing with --rm or --list
    if [[ "${words[1]}" == "wt" ]] && ([[ "${words[2]}" == "--rm" ]] || [[ "${words[2]}" == "--list" ]]); then
        case "${words[2]}" in
            --list)
                # No completion needed for --list
                return 0
                ;;
            --rm)
                # Handle --rm completion
                case $CURRENT in
                    3)
                        # Complete project names
                        local -a projects
                        for dir in $projects_dir/*(N/); do
                            if [[ -d "$dir/.git" ]]; then
                                projects+=(${dir:t})
                            fi
                        done
                        _describe -t projects 'project' projects && return 0
                        ;;
                    4)
                        # Complete worktree names
                        local project="${words[3]}"
                        if [[ -n "$project" && -d "$worktrees_dir/$project" ]]; then
                            local -a worktrees
                            for wt in $worktrees_dir/$project/*(N/); do
                                worktrees+=(${wt:t})
                            done
                            if (( ${#worktrees} > 0 )); then
                                _describe -t worktrees 'worktree to remove' worktrees
                            fi
                        fi
                        return 0
                        ;;
                    *)
                        return 0
                        ;;
                esac
                ;;
        esac
        return 0
    fi
    
    # Define the main arguments for normal usage
    _arguments -C \
        '(--rm)--list[List all worktrees]' \
        '(--list)--rm[Remove a worktree]' \
        '1: :->project' \
        '2: :->worktree' \
        '3: :->command' \
        '*:: :->command_args' \
        && return 0
    
    case $state in
        project)
            
            # Get list of projects (directories in ~/git that are git repos)
            local -a projects
            for dir in $projects_dir/*(N/); do
                if [[ -d "$dir/.git" ]]; then
                    projects+=(${dir:t})
                fi
            done
            
            _describe -t projects 'project' projects && return 0
            ;;
            
        worktree)
            local project="${words[2]}"
            
            if [[ -z "$project" ]]; then
                return 0
            fi
            
            local -a worktrees
            
            # Check for existing worktrees
            if [[ -d "$worktrees_dir/$project" ]]; then
                for wt in $worktrees_dir/$project/*(N/); do
                    worktrees+=(${wt:t})
                done
            fi
            
            if (( ${#worktrees} > 0 )); then
                _describe -t worktrees 'existing worktree' worktrees
            else
                _message 'new worktree name'
            fi
            ;;
            
        command)
            # Suggest common commands when user has typed project and worktree
            local -a common_commands
            common_commands=(
                'cb:Start Claude Bypass session'
                'gst:Git status'
                'gaa:Git add all'
                'gcmsg:Git commit with message'
                'gp:Git push'
                'gco:Git checkout'
                'gd:Git diff'
                'gl:Git log'
                'npm:Run npm commands'
                'yarn:Run yarn commands'
                'make:Run make commands'
            )
            
            _describe -t commands 'command' common_commands
            
            # Also complete regular commands
            _command_names -e
            ;;
            
        command_args)
            # Let zsh handle completion for the specific command
            words=(${words[4,-1]})
            CURRENT=$((CURRENT - 3))
            _normal
            ;;
    esac
}

compdef _wt wt

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