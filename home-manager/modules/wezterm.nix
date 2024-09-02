{pkgs, ...}: let
  inherit (pkgs) stdenv;
  inherit (stdenv) isLinux;
in {
  home.packages = [(pkgs.nerdfonts.override {fonts = ["FiraCode"];})];
  programs.wezterm = {
    enable = true;
    colorSchemes.onedarkpro = {
      background = "#000000";
      foreground = "#abb2bf";
      selection_bg = "#d55fde";
      selection_fg = "#abb2bf";
      ansi = [
        "#000000"
        "#ef596f"
        "#89ca78"
        "#e5c07b"
        "#61afef"
        "#d55fde"
        "#2bbac5"
        "#abb2bf"
      ];
      brights = [
        "#434852"
        "#f38897"
        "#a9d89d"
        "#edd4a6"
        "#8fc6f4"
        "#e089e7"
        "#4bced8"
        "#c8cdd5"
      ];
    };
    extraConfig = ''
      local w = require('wezterm')
      local config = w.config_builder()
      local os_name = '${
        if isLinux
        then "linux"
        else "macos"
      }'

      local w = require('wezterm')

      local function is_vim(pane)
        return pane:get_user_vars().IS_NVIM == 'true'
      end

      local direction_keys = {
        h = 'Left',
        j = 'Down',
        k = 'Up',
        l = 'Right',
      }

      local function split_nav(resize_or_move, key)
        return {
          key = key,
          mods = resize_or_move == 'resize' and 'META' or 'CTRL',
          action = w.action_callback(function(win, pane)
            if is_vim(pane) then
              -- pass the keys through to vim/nvim
              win:perform_action({
                SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
              }, pane)
            else
              if resize_or_move == 'resize' then
                win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
              else
                win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
              end
            end
          end),
        }
      end

      -- macOS specific settings
      -- this setting behaves weirdly on linux
      config.hide_mouse_cursor_when_typing = os_name == 'macos'
      if os_name == 'macos' then
        config.window_decorations = 'RESIZE'
      end

      config.color_scheme = 'onedarkpro'
      config.cursor_blink_rate = 0
      config.font = w.font_with_fallback({"MonoLisa", "FiraCode Nerd Font"})
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
        sha256 = "6kfDItoEvLt/MQpe8R6KKNhFIWHYTXDL1JJ+va6fG/0=";
      }
    }
  '';
}
