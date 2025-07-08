{pkgs, ...}: let
  inherit (pkgs) stdenv;
  inherit (stdenv) isDarwin;
  inherit (stdenv) isLinux;
in {
  # Ghostty is installed via Homebrew (Brewfile.mars)
  # This module only provides configuration

  xdg.configFile."ghostty/config" = {
    text = ''
      # Theme
      theme = tokyonight_moon

      # Font configuration
      font-family = Iosevka Nerd Font
      font-size = 14

      # Window configuration
      window-padding-x = 0
      window-padding-y = 2
      window-save-state = always

      # macOS specific settings
      ${
        if isDarwin
        then ''
          macos-titlebar-style = tabs
          macos-titlebar-proxy-icon = visible
          mouse-hide-while-typing = true
          macos-option-as-alt = true
        ''
        else ""
      }

      # Window behavior
      window-inherit-working-directory = true
      window-inherit-font-size = true

      # Cursor
      cursor-style = block
      cursor-style-blink = false

      # Background opacity
      background-opacity = 1.0

      # Performance
      ${
        if isDarwin
        then ''
          macos-non-native-fullscreen = true
        ''
        else ""
      }

      # Shell integration - enables tab naming, directory tracking, etc
      shell-integration = detect
      shell-integration-features = cursor,sudo,title

      # Copy on select
      copy-on-select = false
      clipboard-read = allow
      clipboard-write = allow
      clipboard-paste-protection = false

      # Scrollback
      scrollback-limit = 10000
      
      # Mouse scrolling
      mouse-scroll-multiplier = 3

      # Window
      confirm-close-surface = true
      quit-after-last-window-closed = false

      # Focus follows mouse for better multi-tab workflow
      focus-follows-mouse = false

      # Window decorations
      window-decoration = true
    '';
  };
}
