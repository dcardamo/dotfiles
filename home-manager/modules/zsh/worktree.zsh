#!/usr/bin/env zsh
# Multi-project worktree manager with Claude support
# 
# ASSUMPTIONS & SETUP:
# - Your git projects live in: ~/git/
# - Worktrees will be created in: ~/git/wt/<project>/<branch>
# - New branches will be named: <your-username>/<feature-name>
#
# DIRECTORY STRUCTURE EXAMPLE:
# ~/git/
# ├── my-app/              (main git repo)
# ├── another-project/     (main git repo)
# └── wt/
#     ├── my-app/
#     │   ├── feature-x/   (worktree)
#     │   └── bugfix-y/    (worktree)
#     └── another-project/
#         └── new-feature/ (worktree)
#
# CUSTOMIZATION:
# To use different directories, modify these lines in the wt() function:
#   local projects_dir="$HOME/git"
#   local worktrees_dir="$HOME/git/wt"
#
# INSTALLATION:
# This file is automatically sourced by home-manager zsh configuration
#
# USAGE:
#   wt <project> <worktree>              # cd to worktree (creates if needed)
#   wt <project> <worktree> <command>    # run command in worktree
#   wt --list                            # list all worktrees
#   wt --rm <project> <worktree>         # remove worktree
#
# EXAMPLES:
#   wt myapp feature-x                   # cd to feature-x worktree
#   wt myapp feature-x cb                # run claude bypass in worktree
#   wt myapp feature-x gst               # git status in worktree
#   wt myapp feature-x gcmsg "fix: bug"  # git commit in worktree

# Multi-project worktree manager
wt() {
    local projects_dir="$HOME/git"
    local worktrees_dir="$HOME/git/wt"
    
    # Check if no arguments provided
    if [[ $# -eq 0 ]]; then
        echo "Usage: wt <project> <worktree> [command...]"
        echo "       wt --list"
        echo "       wt --rm <project> <worktree>"
        return 1
    fi
    
    # Handle special flags
    if [[ "$1" == "--list" ]]; then
        echo "=== All Worktrees ==="
        # Check new location
        if [[ -d "$worktrees_dir" ]]; then
            for project in $worktrees_dir/*(/N); do
                project_name=$(basename "$project")
                echo "\n[$project_name]"
                for wt in $project/*(/N); do
                    echo "  • $(basename "$wt")"
                done
            done
        fi
        return 0
    elif [[ "$1" == "--rm" ]]; then
        if [[ $# -lt 3 ]]; then
            echo "Usage: wt --rm <project> <worktree>"
            return 1
        fi
        shift
        local project="$1"
        local worktree="$2"
        if [[ -z "$project" || -z "$worktree" ]]; then
            echo "Usage: wt --rm <project> <worktree>"
            return 1
        fi
        local wt_path="$worktrees_dir/$project/$worktree"
        if [[ ! -d "$wt_path" ]]; then
            echo "Worktree not found: $wt_path"
            return 1
        fi
        
        # Get the branch name before removing the worktree
        local branch_name=$(cd "$wt_path" && git branch --show-current)
        
        # Remove the worktree
        echo "Removing worktree: $worktree"
        (cd "$projects_dir/$project" && git worktree remove "$wt_path") || {
            echo "Failed to remove worktree"
            return 1
        }
        
        # Delete the branch if it exists
        if [[ -n "$branch_name" ]]; then
            echo "Deleting branch: $branch_name"
            (cd "$projects_dir/$project" && git branch -D "$branch_name" 2>/dev/null) && {
                echo "Branch deleted successfully"
            } || {
                echo "Branch could not be deleted (might be checked out elsewhere or doesn't exist)"
            }
        fi
        
        return 0
    fi
    
    # Normal usage: wt <project> <worktree> [command...]
    local project="$1"
    local worktree="$2"
    
    # Only shift if we have at least 2 arguments
    if [[ $# -ge 2 ]]; then
        shift 2
        local command=("$@")
    else
        local command=()
    fi
    
    if [[ -z "$project" || -z "$worktree" ]]; then
        echo "Usage: wt <project> <worktree> [command...]"
        echo "       wt --list"
        echo "       wt --rm <project> <worktree>"
        return 1
    fi
    
    # Check if project exists
    if [[ ! -d "$projects_dir/$project" ]]; then
        echo "Project not found: $projects_dir/$project"
        return 1
    fi
    
    # Determine worktree path
    local wt_path=""
    if [[ -d "$worktrees_dir/$project/$worktree" ]]; then
        wt_path="$worktrees_dir/$project/$worktree"
    fi
    
    # If worktree doesn't exist, create it
    if [[ -z "$wt_path" || ! -d "$wt_path" ]]; then
        echo "Creating new worktree: $worktree"
        
        # Ensure worktrees directory exists
        mkdir -p "$worktrees_dir/$project"
        
        # Determine branch name (use current username prefix)
        local branch_name="$USER/$worktree"
        
        # Create the worktree in new location
        wt_path="$worktrees_dir/$project/$worktree"
        (cd "$projects_dir/$project" && git worktree add "$wt_path" -b "$branch_name") || {
            echo "Failed to create worktree"
            return 1
        }
        
        # Symlink .env file if it exists in the main project
        if [[ -f "$projects_dir/$project/.env" ]]; then
            echo "Found .env file - creating symlink in worktree"
            ln -sf "$projects_dir/$project/.env" "$wt_path/.env"
        fi
        
        # Auto-allow direnv if .envrc exists
        if [[ -f "$wt_path/.envrc" ]]; then
            echo "Found .envrc - running direnv allow"
            (cd "$wt_path" && direnv allow)
        fi
    fi
    
    # Execute based on number of arguments
    if [[ ${#command[@]} -eq 0 ]]; then
        # No command specified - just cd to the worktree
        cd "$wt_path"
    else
        # Command specified - run it in the worktree without cd'ing
        local old_pwd="$PWD"
        cd "$wt_path"
        eval "${command[@]}"
        local exit_code=$?
        cd "$old_pwd"
        return $exit_code
    fi
}

