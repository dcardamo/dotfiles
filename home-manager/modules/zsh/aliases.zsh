#!/usr/bin/env zsh
# Shell aliases

# Basic command replacements
alias cat="bat"
alias df="duf"
alias tar="tar --use-compress-program='pigz -p 24'"
alias clear="clear && tput cup \$(tput lines)"

# ls aliases using lsd
alias ls="lsd --group-directories-first"
alias la="ls -a"
alias ll="ls -l --git"
alias l="ls -laH"
alias lg="ls -lG"

# Mac-specific aliases
if [[ "$OSTYPE" == "darwin"* ]]; then
fi

# Linux-specific aliases
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    alias nixsearch="nix search nixpkgs"
fi

# Zellij tab naming shortcuts
alias zt="update_zellij_tab_name"
alias ztn="zellij_name_tab"

# Ghostty shortcuts
alias gt="ghostty_tab_title"
