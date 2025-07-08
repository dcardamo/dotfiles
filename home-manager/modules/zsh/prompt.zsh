#!/usr/bin/env zsh
# Prompt configuration

# Custom prompt setup
autoload -U colors && colors

# Set up the prompt - override oh-my-zsh theme
setopt PROMPT_SUBST

# Unset oh-my-zsh's git functions to avoid conflicts
unfunction git_prompt_info 2>/dev/null || true
unfunction git_prompt_status 2>/dev/null || true

# Function to get system icon
function get_system_icon() {
    if [[ -f /.dockerenv ]] || [[ -n "$CONTAINER_ID" ]]; then
        echo "🐳"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo $'\ue711' # nf-dev-apple
    else
        echo "🐧"
    fi
}

# Function to get git info
function git_prompt_info() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local branch=$(git branch --show-current 2>/dev/null || echo "detached")
        # Using nf-dev-git_branch icon
        echo " %{$fg_bold[magenta]%}\ue725 $branch%{$reset_color%}"
    fi
}

# Function to get git status
function git_prompt_status() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local git_status=""
        local has_changes=false

        # Check for various git states
        git diff --quiet || { git_status+="!"; has_changes=true; }
        git diff --cached --quiet || { git_status+="+"; has_changes=true; }
        [[ -n $(git ls-files --others --exclude-standard) ]] && { git_status+="?"; has_changes=true; }

        # Check if we're ahead or behind
        local upstream=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
        if [[ -n "$upstream" ]]; then
            local ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null)
            local behind=$(git rev-list --count HEAD..@{u} 2>/dev/null)
            [[ "$ahead" -gt 0 ]] && git_status+="⇡$ahead"
            [[ "$behind" -gt 0 ]] && git_status+="⇣$behind"
            [[ "$ahead" -gt 0 || "$behind" -gt 0 ]] && has_changes=true
        fi

        if [[ "$has_changes" == true ]]; then
            echo " %{$fg[yellow]%}[$git_status]%{$reset_color%}"
        fi
    fi
}

# Define our custom prompt
PROMPT='$(get_system_icon) %{$fg[cyan]%}%m%{$reset_color%} %{$fg[blue]%}%~%{$reset_color%}$(git_prompt_info)$(git_prompt_status)
%{$fg_bold[magenta]%}»%{$reset_color%} '

# Disable oh-my-zsh's git prompt (if it exists)
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""

# Hook functions for auto-updating tab names
# Auto-update tab name on directory change
chpwd() {
    update_zellij_tab_name
}

# Auto-update tab name on git branch change
precmd() {
    update_zellij_tab_name
}