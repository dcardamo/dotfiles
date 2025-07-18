#!/usr/bin/env zsh
# Shell functions

# Ghostty tab title function
if [ -n "$GHOSTTY_RESOURCES_DIR" ]; then
    ghostty_tab_title() {
        if [ -n "$1" ]; then
            printf "\033]0;%s\007" "$1"
        fi
    }
fi

# Zellij tab naming with git branch support
update_zellij_tab_name() {
    if [ -n "$ZELLIJ" ]; then
        local tab_name=""
        local dir_name=""
        local branch=""

        # Get git branch if in a git repo
        if git rev-parse --git-dir > /dev/null 2>&1; then
            # Get git repository root directory name
            local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
            if [ -n "$git_root" ]; then
                # Check if we're in a git worktree
                local git_dir=$(git rev-parse --git-dir 2>/dev/null)
                if [[ "$git_dir" == *"/worktrees/"* ]]; then
                    # We're in a worktree, find the main repository
                    # Extract main repo path from worktree git-dir
                    local main_git_dir=$(echo "$git_dir" | sed 's|/worktrees/.*||')
                    local main_repo_root=$(dirname "$main_git_dir")

                    # Check if main repo ends with /index or /main, use parent dir
                    if [[ "$main_repo_root" == */index ]] || [[ "$main_repo_root" == */main ]]; then
                        dir_name=$(basename "$(dirname "$main_repo_root")")
                    else
                        dir_name=$(basename "$main_repo_root")
                    fi
                else
                    # Regular git repo (not a worktree)
                    if [[ "$git_root" == */index ]] || [[ "$git_root" == */main ]]; then
                        dir_name=$(basename "$(dirname "$git_root")")
                    else
                        dir_name=$(basename "$git_root")
                    fi
                fi
            else
                dir_name=$(basename "$PWD")
            fi

            branch=$(git branch --show-current 2>/dev/null)
            if [ -n "$branch" ]; then
                tab_name="$dir_name [$branch]"
            else
                tab_name="$dir_name"
            fi
        else
            # Not in a git repo, use current directory name
            dir_name=$(basename "$PWD")
            tab_name="$dir_name"
        fi

        # Update Zellij tab name
        command zellij action rename-tab "$tab_name" > /dev/null 2>&1
    fi
}

# Manual tab naming command
zellij_name_tab() {
    if [ -n "$ZELLIJ" ]; then
        if [ -n "$1" ]; then
            command zellij action rename-tab "$1"
        else
            echo "Usage: zellij_name_tab <tab_name>"
        fi
    else
        echo "Not in a Zellij session"
    fi
}

# GitHub PR creation helper
ghpr() {
    local title="$1"
    local body="$2"

    # Get current branch name
    local branch=$(git rev-parse --abbrev-ref HEAD)

    # Get the base branch (usually main or master)
    local base=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")

    if [ -z "$title" ]; then
        # Generate title from branch name or last commit
        title=$(git log -1 --pretty=format:"%s")
    fi

    if [ -z "$body" ]; then
        # Generate body from commit messages since base branch
        body=$(git log $base..$branch --pretty=format:"- %s" --reverse)
        # If no commits found, use the last commit message body
        if [ -z "$body" ]; then
            body=$(git log -1 --pretty=format:"%b")
        fi
    fi

    # Create PR
    gh pr create --base "$base" --head "$branch" --title "$title" --body "$body"
}

# Claude Bypass function (CB)
cb() {
    if [[ -f /.dockerenv ]] || [[ -n "$CONTAINER_ID" ]]; then
        # In Docker container, use claude directly
        claude --dangerously-skip-permissions "$@"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # On Linux, use claude directly
        claude --dangerously-skip-permissions "$@"
    else
        # On Mac, use claude-mac-sandbox
        claude-mac-sandbox run --dangerously-skip-permissions "$@"
    fi
}

# Gemini Bypass function (GB)
# Unalias gb from oh-my-zsh git plugin
unalias gb 2>/dev/null || true
gb() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # On Linux, run without isolation
        gemini --sandbox.mode=linux-user --sandbox.auto-approve "$@"
    else
        # On Mac, use seatbelt
        gemini --sandbox.mode=darwin-seatbelt --sandbox.auto-approve "$@"
    fi
}

# Helper function to list worktrees for completion
__git_worktrees() {
    local -a worktrees
    worktrees=(${${(f)"$(git worktree list --porcelain 2>/dev/null | grep '^worktree' | cut -d' ' -f2-)"}%%:*})
    _describe -t worktrees 'worktree' worktrees
}
