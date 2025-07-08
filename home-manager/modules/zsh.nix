{
  pkgs,
  lib,
  vars,
  ...
}: let
  inherit (pkgs) stdenv;
  inherit (stdenv) isLinux;
  inherit (stdenv) isDarwin;
in {
  home.packages = with pkgs;
    [
      tealdeer
      tokei
    ]
    ++ lib.lists.optionals isLinux [];

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
        "sudo"
      ];
      theme = ""; # Disable theme, we'll use custom prompt
    };

    sessionVariables = {
      HOMEBREW_NO_ANALYTICS = "1";
      CARGO_NET_GIT_FETCH_WITH_CLI = "true";
      GOPATH = "$HOME/go";
      GIT_MERGE_AUTOEDIT = "no";
      NEXT_TELEMETRY_DISABLED = "1";
      # EDITOR = "hx"; # Now set in neovim.nix
      # VISUAL = "hx"; # Now set in neovim.nix
      # GIT_EDITOR = "hx"; # Now set in neovim.nix
      COLORTERM = "truecolor";
      NIXPKGS_ALLOW_UNFREE = 1;
      NPM_CONFIG_PREFIX = "$HOME/.npm-global";
      # Add Nix profile to PATH for non-interactive sessions
      PATH = "$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH";
      # Locale settings for proper Unicode/Nerd Font support
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      # Puppeteer configuration
      PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = "true";
      PUPPETEER_EXECUTABLE_PATH = "/usr/bin/chromium-browser";
    };

    # Dynamic aliases using vars for platform-specific copy/paste
    shellAliases = {
      copy = vars.copyCmd;
      paste = vars.pasteCmd;
    };

    # initContent runs for interactive shells
    initContent = ''
      # Source all our custom zsh config files
      source ${./zsh/init.zsh}
      source ${./zsh/functions.zsh}
      source ${./zsh/aliases.zsh}
      source ${./zsh/completions.zsh}
      source ${./zsh/prompt.zsh}
    '';
  };
}