#!/usr/bin/env zsh
# Shell aliases

# Basic command replacements
alias cat="bat"
alias "!!"="fc -s"
alias df="duf"
alias tar="tar --use-compress-program='pigz -p 24'"
alias clear="clear && tput cup \$(tput lines)"
alias sqlite3="litecli"

# ls aliases using lsd
alias ls="lsd --group-directories-first"
alias la="ls -a"
alias ll="ls -l --git"
alias l="ls -laH"
alias lg="ls -lG"

# Cargo testing shortcuts
alias cargotest="cargo nextest run"
alias cargotestnc="cargo nextest run --nocapture"
alias wcargotest="watchexec -r -e rs,toml cargo nextest run"
alias wcargotestnc="watchexec -r -e rs,toml cargo nextest run --nocapture"

# Mac-specific aliases
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias fps_on="launchctl setenv MTL_HUD_ENABLED 1"
    alias fps_off="launchctl setenv MTL_HUD_ENABLED 0"
fi

# Linux-specific aliases
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    alias cfgnix="sudo nvim /etc/nixos/configuration.nix"
    alias restart-gui="sudo systemctl restart display-manager.service"
    alias nixsearch="nix search nixpkgs"
fi

# Zellij tab naming shortcuts
alias zt="update_zellij_tab_name"
alias ztn="zellij_name_tab"

# Claude commands
alias cmcp="claude-mcp"
alias cproj="claude-project"
alias csandbox="claude-mac-sandbox"
alias csqlite="claude-mcp sqlite"
alias cdocs="echo 'Just add \"use context7\" to any Claude prompt for up-to-date docs!'"

# Gemini commands
# gb is defined as a function in functions.zsh

# Ghostty shortcuts
alias gt="ghostty_tab_title"