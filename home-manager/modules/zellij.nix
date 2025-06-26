# Zellij Terminal Multiplexer Configuration
#
# This module provides a comprehensive Zellij setup with:
# - Cross-platform clipboard integration (macOS/Linux)
# - Zsh shell integration with tab completion
# - Custom keybindings optimized for productivity
# - Multiple layout templates (default, compact, development)
# - Catppuccin Mocha theme
# - Convenient shell aliases (zj, zja, zjl, etc.)
#
# Key Features:
# - Alt-based keybindings for quick navigation
# - Session management with floating windows
# - File browser integration with Strider plugin
# - Customizable pane layouts for different workflows
# - Mouse support enabled
# - Scrollback buffer of 10,000 lines
# - Tab completion for session names (e.g., zja <TAB>)
#
# Usage:
#   zj           - Start new zellij session
#   zja <name>   - Attach to existing session (with tab completion)
#   zjl          - List all sessions
#   zjd          - Start with development layout
#   zjc          - Start with compact layout
#   zr <cmd>     - Run command in new pane
#   zrf <cmd>    - Run command in new floating pane
#   ze <file>    - Edit file in new pane
{ pkgs, ... }:
let
  inherit (pkgs) stdenv;
  inherit (stdenv) isLinux;
  inherit (stdenv) isDarwin;
in
{
  programs.zellij = {
    enable = true;
    # Disabled to prevent auto-starting Zellij on every new shell/SSH session
    # Use aliases (zj, zja, etc.) to manually start Zellij when needed
    enableZshIntegration = false;
    enableBashIntegration = false;
  };

  # Shell aliases for convenient zellij usage
  programs.zsh.shellAliases = {
    zj = "zellij";
    #zja = "zellij attach";
    zjl = "zellij list-sessions";
    zjk = "zellij kill-session";
    zjda = "zellij delete-all-sessions"; # prunes old sessions
    zjka = "zellij kill-all-sessions";
    zjm = "zellij --layout motive";
    # Additional convenience aliases from zellij setup
    zr = "zellij run --";
    zrf = "zellij run --floating --";
    ze = "zellij edit";
  };

  # Zellij configuration files
  xdg.configFile = {
    # Main configuration file
    "zellij/config.kdl".text = ''
      // Zellij Configuration

      // Basic settings
      pane_frames false
      theme "tokyo-night-moon"
      default_layout "compact"
      mouse_mode false
      scroll_buffer_size 10000
      copy_on_select true
      copy_command "${
        if isDarwin then
          "pbcopy"
        else if isLinux then
          "wl-copy"
        else
          "xclip -selection clipboard"
      }"
      scrollback_editor "hx"
      session_serialization true
      pane_viewport_serialization true
      on_force_close "quit"
      show_release_notes false
      show_startup_tips false

      // UI settings
      ui {
          pane_frames {
              rounded_corners false
              hide_session_name true
          }
      }

      // Simplified keybindings
      keybinds clear-defaults=true {
          normal {
              // Termius-optimized scrolling - compatible with SSH clients
              bind "Shift PageUp" { ScrollUp; }
              bind "Shift PageDown" { ScrollDown; }
              bind "PageUp" { HalfPageScrollUp; }
              bind "PageDown" { HalfPageScrollDown; }
              bind "Home" { ScrollToTop; }
              bind "End" { ScrollToBottom; }

              // Alternative scroll bindings for mobile keyboards
              // Ctrl-u and Ctrl-d removed to preserve shell behavior
              bind "Ctrl b" { PageScrollUp; }
              bind "Ctrl f" { PageScrollDown; }

              // Pane management
              bind "Alt n" { NewPane; }
              bind "Alt h" { NewPane "Down"; }
              bind "Alt v" { NewPane "Right"; }
              bind "Alt q" { CloseFocus; }

              // Focus movement
              bind "Alt Left" { MoveFocus "Left"; }
              bind "Alt Right" { MoveFocus "Right"; }
              bind "Alt Up" { MoveFocus "Up"; }
              bind "Alt Down" { MoveFocus "Down"; }

              // Tab management
              bind "Alt t" { NewTab; }
              bind "Alt 1" { GoToTab 1; }
              bind "Alt 2" { GoToTab 2; }
              bind "Alt 3" { GoToTab 3; }
              bind "Alt 4" { GoToTab 4; }
              bind "Alt 5" { GoToTab 5; }
              bind "Alt 6" { GoToTab 6; }
              bind "Alt 7" { GoToTab 7; }
              bind "Alt 8" { GoToTab 8; }
              bind "Alt 9" { GoToTab 9; }
              bind "Alt Tab" { GoToNextTab; }

              // Session management
              bind "Alt d" { Detach; }
              bind "Alt Enter" { ToggleFocusFullscreen; }
              bind "Alt r" { SwitchToMode "RenameTab"; }
              bind "Alt w" { ToggleFloatingPanes; }

              // Quick search
              bind "Alt /" { SwitchToMode "EnterSearch"; }

              // Switch to modes
              bind "Alt p" { SwitchToMode "Pane"; }
              // Ctrl-r removed to preserve shell reverse search
              bind "Alt z" { SwitchToMode "Resize"; }
              bind "Alt s" { SwitchToMode "Scroll"; }
              bind "Alt t" { SwitchToMode "Tab"; }
              bind "Alt o" { SwitchToMode "Session"; }
          }

          resize {
              bind "Alt z" { SwitchToMode "Normal"; }
              bind "Enter" { SwitchToMode "Normal"; }
              bind "h" "Left" { Resize "Increase Left"; }
              bind "j" "Down" { Resize "Increase Down"; }
              bind "k" "Up" { Resize "Increase Up"; }
              bind "l" "Right" { Resize "Increase Right"; }
              bind "H" { Resize "Decrease Left"; }
              bind "J" { Resize "Decrease Down"; }
              bind "K" { Resize "Decrease Up"; }
              bind "L" { Resize "Decrease Right"; }
              bind "=" "+" { Resize "Increase"; }
              bind "-" { Resize "Decrease"; }
          }

          pane {
              bind "Alt p" { SwitchToMode "Normal"; }
              bind "Enter" { SwitchToMode "Normal"; }
              bind "h" "Left" { MoveFocus "Left"; }
              bind "l" "Right" { MoveFocus "Right"; }
              bind "j" "Down" { MoveFocus "Down"; }
              bind "k" "Up" { MoveFocus "Up"; }
              bind "p" { SwitchFocus; }
              bind "c" { NewPane; }
              bind "d" { NewPane "Down"; }
              bind "r" { NewPane "Right"; }
              bind "x" { CloseFocus; }
              bind "f" { ToggleFocusFullscreen; }
              bind "z" { TogglePaneFrames; }
              bind "w" { ToggleFloatingPanes; }
              bind "e" { TogglePaneEmbedOrFloating; }
              bind "c" { SwitchToMode "RenamePane"; }
          }

          tab {
              bind "Alt t" { SwitchToMode "Normal"; }
              bind "Enter" { SwitchToMode "Normal"; }
              bind "r" { SwitchToMode "RenameTab"; }
              bind "h" "Left" "Up" "k" { MoveFocus "Left"; }
              bind "l" "Right" "Down" "j" { MoveFocus "Right"; }
              bind "c" { NewTab; }
              bind "x" { CloseTab; }
              bind "s" { ToggleActiveSyncTab; }
              bind "1" { GoToTab 1; }
              bind "2" { GoToTab 2; }
              bind "3" { GoToTab 3; }
              bind "4" { GoToTab 4; }
              bind "5" { GoToTab 5; }
              bind "6" { GoToTab 6; }
              bind "7" { GoToTab 7; }
              bind "8" { GoToTab 8; }
              bind "9" { GoToTab 9; }
              bind "Tab" { ToggleTab; }
          }

          scroll {
              bind "Alt s" { SwitchToMode "Normal"; }
              bind "Esc" { SwitchToMode "Normal"; }
              bind "Enter" { SwitchToMode "Normal"; }
              bind "e" { EditScrollback; }
              bind "s" { SwitchToMode "EnterSearch"; }
              bind "Ctrl c" { ScrollToBottom; }
              bind "j" "Down" { ScrollDown; }
              bind "k" "Up" { ScrollUp; }
              bind "Ctrl f" "PageDown" { PageScrollDown; }
              bind "Ctrl b" "PageUp" { PageScrollUp; }
              bind "d" { HalfPageScrollDown; }
              bind "u" { HalfPageScrollUp; }

          }

          search {
              bind "Alt /" { SwitchToMode "Normal"; }
              bind "Esc" { SwitchToMode "Normal"; }
              bind "Enter" { SwitchToMode "Normal"; }
              bind "Ctrl c" { ScrollToBottom; SwitchToMode "Normal"; }
              bind "j" "Down" { ScrollDown; }
              bind "k" "Up" { ScrollUp; }
              bind "Ctrl f" "PageDown" { PageScrollDown; }
              bind "Ctrl b" "PageUp" { PageScrollUp; }
              bind "d" { HalfPageScrollDown; }
              bind "u" { HalfPageScrollUp; }
              bind "n" { Search "down"; }
              bind "p" { Search "up"; }
              bind "c" { SearchToggleOption "CaseSensitivity"; }
              bind "w" { SearchToggleOption "Wrap"; }
              bind "o" { SearchToggleOption "WholeWord"; }
          }

          entersearch {
              bind "Ctrl c" "Esc" { SwitchToMode "Scroll"; }
              bind "Enter" { SwitchToMode "Search"; }
          }

          renametab {
              bind "Ctrl c" { SwitchToMode "Normal"; }
              bind "Esc" { UndoRenameTab; SwitchToMode "Tab"; }
              bind "Enter" { SwitchToMode "Normal"; }
          }

          renamepane {
              bind "Ctrl c" { SwitchToMode "Normal"; }
              bind "Esc" { UndoRenamePane; SwitchToMode "Pane"; }
              bind "Enter" { SwitchToMode "Normal"; }
          }

          session {
              bind "Alt o" { SwitchToMode "Normal"; }
              bind "Enter" { SwitchToMode "Normal"; }
              bind "d" { Detach; }
              bind "w" {
                  LaunchOrFocusPlugin "zellij:session-manager" {
                      floating true
                      move_to_focused_tab true
                  }
                  SwitchToMode "Normal"
              }
          }
      }

      // Plugin configuration
      plugins {
          tab-bar { path "tab-bar"; }
          status-bar { path "status-bar"; }
          strider { path "strider"; }
          compact-bar { path "compact-bar"; }
          session-manager { path "session-manager"; }
      }
    '';

    # Custom layout files
    "zellij/layouts/default.kdl".text = ''
      layout {
          pane size=1 borderless=true {
              plugin location="zellij:tab-bar"
          }
          pane borderless=true
      }
    '';

    "zellij/layouts/compact.kdl".text = ''
      layout {
          pane size=1 borderless=true {
              plugin location="zellij:compact-bar"
          }
          pane borderless=true
      }
    '';

    # Mobile-friendly layout with 4 predefined tabs for motive development
    "zellij/layouts/motive.kdl".text = ''
      layout {
          default_tab_template {
              pane size=1 borderless=true {
                  plugin location="zellij:compact-bar"
              }
              children
          }
          tab name="sh" cwd="~" {
              pane borderless=true
          }
          tab name="mtv" cwd="~/git/mtv/index" {
              pane borderless=true
          }
          tab name="mtv2" cwd="~/git/mtv/index" {
              pane borderless=true
          }
          tab name="mtv3" cwd="~/git/mtv/index" {
              pane borderless=true
          }
          tab name="dotfiles" cwd="~/git/dotfiles" {
              pane borderless=true
          }
      }
    '';

    # Custom theme - Tokyo Night Moon
    "zellij/themes/tokyo-night-moon.kdl".text = ''
      themes {
          tokyo-night-moon {
              bg "#222436"      // Background
              fg "#c8d3f5"      // Foreground
              red "#ff757f"     // Red
              green "#c3e88d"   // Green
              blue "#82aaff"    // Blue
              yellow "#ffc777"  // Yellow
              magenta "#c099ff" // Magenta/Purple
              orange "#ff966c"  // Orange
              cyan "#86e1fc"    // Cyan
              black "#1e2030"   // Black/Dark
              white "#c8d3f5"   // White/Light
          }
      }
    '';
  };
}
