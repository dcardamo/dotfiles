# Tmux Terminal Multiplexer Configuration
#
# This module provides a comprehensive tmux setup with:
# - Keybindings similar to the zellij configuration
# - Cross-platform clipboard integration (macOS/Linux)
# - Neovim integration
# - Shift+Tab support for Claude Code
# - Tokyo Night Moon theme matching zellij
# - Mouse support
# - Session management
#
# Key Features:
# - Alt-based keybindings for quick navigation (matching zellij)
# - Seamless navigation between tmux panes and neovim splits
# - Shift+Tab character support for Claude Code
# - 10,000 lines of scrollback
# - Visual activity notifications
#
# Usage:
#   tmux         - Start new tmux session
#   tmux a       - Attach to existing session
#   tmux ls      - List all sessions
#   tmux new -s <name>  - Create named session
{pkgs, lib, ...}: let
  inherit (pkgs) stdenv;
  inherit (stdenv) isLinux isDarwin;
in {
  programs.tmux = {
    enable = true;
    
    # Match zellij's shell
    shell = "${pkgs.zsh}/bin/zsh";
    
    # Essential settings
    terminal = "screen-256color";
    historyLimit = 10000;
    escapeTime = 0;
    mouse = true;
    keyMode = "vi";
    
    # Use Alt as prefix (matching zellij's Alt-based bindings)
    # We'll use most keybindings without prefix for consistency with zellij
    prefix = null;  # No prefix key - direct Alt bindings
    
    # Base configuration
    extraConfig = ''
      # Terminal overrides for proper colors
      set-option -ga terminal-overrides ",xterm-256color:Tc"
      set-option -ga terminal-overrides ",screen-256color:Tc"
      
      # Enable focus events (needed for vim integration)
      set-option -g focus-events on
      
      # Window and pane indexing
      set -g base-index 1
      setw -g pane-base-index 1
      set -g renumber-windows on
      
      # Visual activity
      setw -g monitor-activity on
      set -g visual-activity off
      
      # Status bar position (top like zellij)
      set -g status-position top
      
      # ===== KEYBINDINGS (Matching Zellij) =====
      
      # Unbind all default keys first
      unbind-key -a
      
      # Basic tmux management (using Ctrl+b as prefix for these)
      set -g prefix C-b
      bind C-b send-prefix
      bind : command-prompt
      bind ? list-keys
      bind q display-panes
      
      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"
      
      # ===== PANE MANAGEMENT (Matching Zellij) =====
      
      # Create new panes (Alt+n, Alt+h, Alt+v)
      bind -n M-n split-window -c "#{pane_current_path}"
      bind -n M-h split-window -v -c "#{pane_current_path}"
      bind -n M-v split-window -h -c "#{pane_current_path}"
      
      # Close pane (Alt+q)
      bind -n M-q kill-pane
      
      # Focus movement with Alt+arrows
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      
      # Focus movement with Alt+hjkl (vim-style)
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R
      
      # Pane resizing with Shift+Alt+arrows (matching zellij)
      bind -n S-M-Left resize-pane -L 2
      bind -n S-M-Right resize-pane -R 2
      bind -n S-M-Up resize-pane -U 2
      bind -n S-M-Down resize-pane -D 2
      
      # Toggle fullscreen (Alt+Enter)
      bind -n M-Enter resize-pane -Z
      
      # ===== TAB/WINDOW MANAGEMENT (Matching Zellij) =====
      
      # New tab/window (Alt+t)
      bind -n M-t new-window -c "#{pane_current_path}"
      
      # Navigate tabs with Alt+Left/Right
      bind -n M-Left previous-window
      bind -n M-Right next-window
      
      # Direct tab access (Alt+1-9)
      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9
      
      # Tab cycling (Alt+Tab)
      bind -n M-Tab next-window
      
      # Rename window (Alt+r)
      bind -n M-r command-prompt -p "rename-window:" "rename-window '%%'"
      
      # ===== SESSION MANAGEMENT =====
      
      # Detach (Alt+d)
      bind -n M-d detach-client
      
      # Session manager (Alt+Shift+D) - tmux's choose-tree
      bind -n M-D choose-tree -Zs
      
      # ===== SCROLLING (Matching Zellij) =====
      
      # Enter scroll mode (Alt+s)
      bind -n M-s copy-mode
      
      # Termius-optimized scrolling
      bind -n S-PageUp copy-mode \; send-keys -X page-up
      bind -n S-PageDown copy-mode \; send-keys -X page-down
      bind -n PageUp copy-mode \; send-keys -X halfpage-up
      bind -n PageDown copy-mode \; send-keys -X halfpage-down
      bind -n Home copy-mode \; send-keys -X history-top
      bind -n End copy-mode \; send-keys -X history-bottom
      
      # Alternative scroll bindings
      bind -n C-b copy-mode \; send-keys -X page-up
      bind -n C-f copy-mode \; send-keys -X page-down
      
      # Search (Alt+/)
      bind -n M-/ copy-mode \; command-prompt -p "search:" "send -X search-forward '%%'"
      
      # ===== COPY MODE (vi-style) =====
      
      # Setup vi-style copy mode
      setw -g mode-keys vi
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind -T copy-mode-vi Escape send-keys -X cancel
      
      # Copy to system clipboard
      ${if isDarwin then ''
        bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
        bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"
      '' else ''
        bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -selection clipboard"
        bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -selection clipboard"
      ''}
      
      # ===== SHIFT+TAB SUPPORT FOR CLAUDE CODE =====
      
      # This is crucial for Claude Code on mobile/SSH
      # Bind Shift+Tab to send the actual shift+tab escape sequence
      bind -n BTab send-keys Escape "[Z"
      
      # Alternative method if the above doesn't work
      # bind -n S-Tab send-keys Escape "[Z"
      
      # ===== FLOATING PANES (popup windows) =====
      
      # Toggle floating pane (Alt+w) - using tmux's popup feature
      bind -n M-w if -F '#{==:#{session_windows},1}' \
        'display-message "No popup in single window"' \
        'display-popup -E -w 80% -h 80%'
      
      # ===== LOCKED MODE =====
      
      # Toggle locked mode (Alt+g)
      bind -n M-g if -F '#{s/off//:status}' 'set status off' 'set status on'
      
      # ===== THEME: Tokyo Night Moon (Matching Zellij) =====
      
      # Colors from zellij config
      # bg "#222436"      # Background
      # fg "#c8d3f5"      # Foreground
      # red "#ff757f"     # Red
      # green "#c3e88d"   # Green
      # blue "#82aaff"    # Blue
      # yellow "#ffc777"  # Yellow
      # magenta "#c099ff" # Magenta/Purple
      # orange "#ff966c"  # Orange
      # cyan "#86e1fc"    # Cyan
      # black "#1e2030"   # Black/Dark
      # white "#c8d3f5"   # White/Light
      
      # Status bar styling
      set -g status-style "bg=#222436,fg=#c8d3f5"
      set -g status-left-length 50
      set -g status-right-length 50
      
      # Left side: session name
      set -g status-left "#[bg=#82aaff,fg=#222436,bold] #S #[bg=#222436,fg=#82aaff]"
      
      # Right side: time and date
      set -g status-right "#[bg=#222436,fg=#86e1fc]#[bg=#86e1fc,fg=#222436] %H:%M #[bg=#222436,fg=#c099ff]#[bg=#c099ff,fg=#222436] %Y-%m-%d "
      
      # Window status
      setw -g window-status-format "#[bg=#222436,fg=#c8d3f5] #I:#W "
      setw -g window-status-current-format "#[bg=#82aaff,fg=#222436,bold] #I:#W "
      setw -g window-status-separator ""
      
      # Pane borders
      set -g pane-border-style "fg=#1e2030"
      set -g pane-active-border-style "fg=#82aaff"
      
      # Message styling
      set -g message-style "bg=#ffc777,fg=#222436"
      set -g message-command-style "bg=#ffc777,fg=#222436"
      
      # ===== NEOVIM INTEGRATION =====
      
      # Smart pane switching with awareness of Vim splits
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      
      # Restore clear screen (C-l) - use prefix C-l
      bind C-l send-keys 'C-l'
      
      # ===== ADDITIONAL FEATURES =====
      
      # Quick command execution (like zellij's zr and zrf)
      bind -n M-x command-prompt -p "command:" "split-window -c '#{pane_current_path}' '%%'"
      bind -n M-X command-prompt -p "command:" "display-popup -E -w 80% -h 80% '%%'"
      
      # Quick edit (like zellij's ze)
      bind -n M-e command-prompt -p "edit:" "split-window -c '#{pane_current_path}' 'hx %%'"
    '';
    
    # Plugins for tmux
    plugins = with pkgs.tmuxPlugins; [
      # Neovim integration
      vim-tmux-navigator
      
      # Session management
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-strategy-nvim 'session'
        '';
      }
      
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'
        '';
      }
    ];
  };
  
  # Shell aliases for tmux (similar to zellij aliases)
  programs.zsh.shellAliases = {
    tm = "tmux";
    tma = "tmux attach-session -t";
    tml = "tmux list-sessions";
    tmk = "tmux kill-session -t";
    tmka = "tmux kill-server";
    tmn = "tmux new-session -s";
  };
  
  # Add tmux session name completion for zsh
  programs.zsh.initContent = ''
    # Tmux session completion
    _tmux_sessions() {
      local sessions
      sessions=($(tmux list-sessions -F '#S' 2>/dev/null))
      _describe 'sessions' sessions
    }
    
    compdef '_tmux_sessions' tma
    compdef '_tmux_sessions' tmk
  '';
}