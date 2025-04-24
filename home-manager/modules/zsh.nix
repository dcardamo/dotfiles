{ pkgs
, lib
, vars
, ...
}:
let
  inherit (pkgs) stdenv;
  inherit (stdenv) isLinux;
  inherit (stdenv) isDarwin;
in
{
  home.packages = with pkgs;
    [ tealdeer tokei ] ++ lib.lists.optionals isLinux [ ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.size = 10000;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "z"
        "direnv"
        "fzf"
        "npm"
        "tmux"
        "sudo"
      ];
      theme = "af-magic";
    };

    sessionVariables = {
      HOMEBREW_NO_ANALYTICS = "1";
      CARGO_NET_GIT_FETCH_WITH_CLI = "true";
      GOPATH = "$HOME/go";
      GIT_MERGE_AUTOEDIT = "no";
      NEXT_TELEMETRY_DISABLED = "1";
      EDITOR = "hx";
      VISUAL = "hx";
      GIT_EDITOR = "hx";
      COLORTERM = "truecolor";
      NIXPKGS_ALLOW_UNFREE = 1;
      NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    };

    shellAliases = {
      copy = vars.copyCmd;
      paste = vars.pasteCmd;
      cat = "bat";
      "!!" = "fc -s";
      ls = "${pkgs.lsd}/bin/lsd --group-directories-first";
      la = "ls -a";
      ll = "ls -l --git";
      l = "ls -laH";
      lg = "ls -lG";
      df = "duf";
      e = "hx";
      tar = "tar --use-compress-program='pigz -p 24'";
      clear = "clear && tput cup \$(tput lines)";
      fps_on = "launchctl setenv MTL_HUD_ENABLED 1";
      fps_off = "launchctl setenv MTL_HUD_ENABLED 0";
      cargotest = "cargo nextest run";
      cargotestnc = "cargo nextest run --nocapture";
      wcargotest = "watchexec -r -e rs,toml cargo nextest run";
      wcargotestnc = "watchexec -r -e rs,toml cargo nextest run --nocapture";
    } // pkgs.lib.optionalAttrs isLinux {
      cfgnix = "sudo nvim /etc/nixos/configuration.nix";
      restart-gui = "sudo systemctl restart display-manager.service";
      nixsearch = "nix search nixpkgs";
      tm = "task-master";
    };

    initContent = ''
      export PROMPT_DIRTRIM=3

      # Source nix files, required to set zsh as default shell, otherwise
      # it doesn\'t have the nix env vars
      if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
        . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
      fi

      # Add npm global bin to path
      export PATH="$HOME/.npm-global/bin:$PATH"

      # Add git/dotfiles/bin to path
      export PATH="$HOME/git/dotfiles/bin:$PATH"

      # Enable direnv
      eval "$(direnv hook zsh)"
    ''
    + lib.strings.optionalString isDarwin ''
      # Mac-specific paths
      export PATH="/opt/homebrew/bin:$HOME/.local/bin:$HOME/.orbstack/bin:$PATH"
    '';
  };
}
