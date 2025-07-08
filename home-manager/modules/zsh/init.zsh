#!/usr/bin/env zsh
# ZSH initialization code

# Source nix files early to ensure PATH is set for all sessions
if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
    . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
fi

# Ensure nix profile bins are in PATH
export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"

# Add npm global bin to path
export PATH="$HOME/.npm-global/bin:$PATH"

# Add git/dotfiles/bin to path
export PATH="$HOME/git/dotfiles/bin:$PATH"

# Platform-specific paths
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac-specific paths - nix paths take precedence
    export PATH="$HOME/.local/bin:$HOME/.orbstack/bin:/opt/homebrew/bin:$PATH"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux-specific paths - ensure .local/bin is available
    export PATH="$HOME/.local/bin:$PATH"
fi

export PROMPT_DIRTRIM=3

# Enable direnv
eval "$(direnv hook zsh)"

# uv shell completions (if uv is installed)
if command -v uv &> /dev/null; then
    eval "$(uv generate-shell-completion zsh)"
fi

# Ghostty shell integration for tab naming and directory tracking
if [ -n "$GHOSTTY_RESOURCES_DIR" ]; then
    source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
fi

# Load ~/.env file if it exists (for secrets)
if [[ -f "$HOME/.env" ]]; then
    # Check file permissions for security
    local env_perms=$(stat -f "%Lp" "$HOME/.env" 2>/dev/null || stat -c "%a" "$HOME/.env" 2>/dev/null)
    if [[ "$env_perms" != "600" ]]; then
        echo "⚠️  Warning: ~/.env has insecure permissions ($env_perms). Run: chmod 600 ~/.env" >&2
    fi
    # Source the file
    set -a  # Mark all new variables for export
    source "$HOME/.env"
    set +a  # Turn off auto-export
else
    echo "⚠️  Warning: ~/.env file not found. Copy ~/.env.template to ~/.env and add your secrets." >&2
    echo "   Run: cp ~/.env.template ~/.env && chmod 600 ~/.env" >&2
fi

# Fix terminal colors for SSH and mosh sessions (especially Termius)
if [[ -n "$SSH_CONNECTION" ]] || [[ -n "$MOSH_CONNECTION" ]] || [[ -n "$MOSH" ]]; then
    # Termius often reports as plain "xterm" but supports 256 colors
    case "$TERM" in
        xterm|vt100|linux)
            export TERM=xterm-256color
            ;;
    esac

    # Ensure COLORTERM is set for true color support
    # This is already set in sessionVariables but may not propagate to SSH/mosh
    export COLORTERM=truecolor
fi