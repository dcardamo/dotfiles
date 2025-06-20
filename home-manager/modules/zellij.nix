# Zellij Terminal Multiplexer Configuration
#
# This module provides a comprehensive Zellij setup with:
# - Cross-platform clipboard integration (macOS/Linux)
# - Fish and Zsh shell integration with tab completion
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
{
  pkgs,
  ...
}: let
  inherit (pkgs) stdenv;
  inherit (stdenv) isLinux;
  inherit (stdenv) isDarwin;
in {
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = false;
    enableBashIntegration = true;
  };

  # Shell aliases for convenient zellij usage
  programs.zsh.shellAliases = {
    zj = "zellij";
    zja = "zellij attach";
    zjl = "zellij list-sessions";
    zjk = "zellij kill-session";
    zjka = "zellij kill-all-sessions";
    zjd = "zellij --layout development";
    zjc = "zellij --layout compact";
    # Additional convenience aliases from zellij setup
    zr = "zellij run --";
    zrf = "zellij run --floating --";
    ze = "zellij edit";
  };

  programs.fish.shellAliases = {
    zj = "zellij";
    zja = "zellij attach";
    zjl = "zellij list-sessions";
    zjk = "zellij kill-session";
    zjka = "zellij kill-all-sessions";
    zjd = "zellij --layout development";
    zjc = "zellij --layout compact";
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
      theme "catppuccin-mocha"
      default_layout "compact"
      mouse_mode true
      scroll_buffer_size 10000
      copy_on_select true
      copy_command "${if isDarwin then "pbcopy" else if isLinux then "wl-copy" else "xclip -selection clipboard"}"
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

              // Switch to modes
              bind "Ctrl p" { SwitchToMode "Pane"; }
              bind "Ctrl r" { SwitchToMode "Resize"; }
              bind "Ctrl s" { SwitchToMode "Scroll"; }
              bind "Ctrl t" { SwitchToMode "Tab"; }
              bind "Ctrl g" { SwitchToMode "Locked"; }
              bind "Ctrl o" { SwitchToMode "Session"; }
          }

          locked {
              bind "Ctrl g" { SwitchToMode "Normal"; }
          }

          resize {
              bind "Ctrl r" { SwitchToMode "Normal"; }
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
              bind "Ctrl p" { SwitchToMode "Normal"; }
              bind "h" "Left" { MoveFocus "Left"; }
              bind "l" "Right" { MoveFocus "Right"; }
              bind "j" "Down" { MoveFocus "Down"; }
              bind "k" "Up" { MoveFocus "Up"; }
              bind "p" { SwitchFocus; }
              bind "n" { NewPane; }
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
              bind "Ctrl t" { SwitchToMode "Normal"; }
              bind "r" { SwitchToMode "RenameTab"; }
              bind "h" "Left" "Up" "k" { MoveFocus "Left"; }
              bind "l" "Right" "Down" "j" { MoveFocus "Right"; }
              bind "n" { NewTab; }
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
              bind "Ctrl s" { SwitchToMode "Normal"; }
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
              bind "Ctrl s" { SwitchToMode "Normal"; }
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
          }

          renamepane {
              bind "Ctrl c" { SwitchToMode "Normal"; }
              bind "Esc" { UndoRenamePane; SwitchToMode "Pane"; }
          }

          session {
              bind "Ctrl o" { SwitchToMode "Normal"; }
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

    "zellij/layouts/development.kdl".text = ''
      layout {
          pane size=1 borderless=true {
              plugin location="zellij:tab-bar"
          }
          pane borderless=true {
              pane split_direction="vertical" {
                  pane borderless=true
                  pane size="30%" borderless=true
              }
              pane size="30%" split_direction="horizontal" borderless=true
          }
      }
    '';

    # Custom theme
    "zellij/themes/catppuccin-mocha.kdl".text = ''
      themes {
          catppuccin-mocha {
              bg "#1e1e2e"
              fg "#cdd6f4"
              red "#f38ba8"
              green "#a6e3a1"
              blue "#89b4fa"
              yellow "#f9e2af"
              magenta "#f5c2e7"
              orange "#fab387"
              cyan "#94e2d5"
              black "#181825"
              white "#f5f5f5"
          }
      }
    '';
  };
}
