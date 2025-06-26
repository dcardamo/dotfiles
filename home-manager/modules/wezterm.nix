{pkgs, ...}: let
  inherit (pkgs) stdenv;
  inherit (stdenv) isLinux;
in {
  home.packages = [
    (
      pkgs.nerd-fonts.fira-code
    )
  ];

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local w = require('wezterm')
      local config = w.config_builder()
      local os_name = '${
        if isLinux
        then "linux"
        else "macos"
      }'

      local w = require('wezterm')

      -- macOS specific settings
      -- this setting behaves weirdly on linux
      config.hide_mouse_cursor_when_typing = os_name == 'macos'
      if os_name == 'macos' then
        config.window_decorations = 'RESIZE'
      end

      config.color_scheme = 'Tokyo Night Moon'
      config.cursor_blink_rate = 0
      config.font = w.font_with_fallback({"MonoLisa", "FiraCode Nerd Font"})
      -- config.font = w.font_with_fallback({"VictorMono Nerd Font Mono", "FiraCode Nerd Font"})
      config.font_size = 13
      config.use_fancy_tab_bar = true
      config.tab_bar_at_bottom = true
      config.hide_tab_bar_if_only_one_tab = true
      config.window_padding = {
        top = 2,
        bottom = 2,
        left = 0,
        right = 0,
      }
      config.debug_key_events = true
      config.inactive_pane_hsb = {
        saturation = 0.7,
        brightness = 0.6,
      }
      config.front_end = 'WebGpu'
      config.webgpu_power_preference = 'HighPerformance'

      return config
    '';
  };
  home.sessionVariables = {TERM = "wezterm";};
  home.activation.installWeztermTerminfo = ''
    ${pkgs.ncurses}/bin/tic -x -o $HOME/.terminfo ${
      pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo";
        sha256 = "sha256-XjhvsUmyoWtxtNmjc8VHN8nlaU62f+ONk7JHBbk0N+0=";
      }
    }
  '';
}
