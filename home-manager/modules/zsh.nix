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
      # Add Nix profile to PATH for non-interactive sessions
      PATH = "$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH";
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
      ai = "claude-mac-sandbox run --dangerously-skip-permissions";
    } // pkgs.lib.optionalAttrs isLinux {
      cfgnix = "sudo nvim /etc/nixos/configuration.nix";
      restart-gui = "sudo systemctl restart display-manager.service";
      nixsearch = "nix search nixpkgs";
    };

    # initExtra runs for all shell types (interactive and non-interactive)
    initExtra = ''
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
    ''
    + lib.strings.optionalString isDarwin ''
      # Mac-specific paths - nix paths take precedence
      export PATH="$HOME/.local/bin:$HOME/.orbstack/bin:/opt/homebrew/bin:$PATH"
    '';
    
    # initContent runs only for interactive shells
    initContent = ''
      export PROMPT_DIRTRIM=3

      # Enable direnv
      eval "$(direnv hook zsh)"

      # Comprehensive zellij completion
      _zellij_sessions() {
        local -a sessions
        sessions=($(zellij list-sessions --short 2>/dev/null))
        if [[ ${#sessions} -gt 0 ]]; then
          _describe 'sessions' sessions
        else
          _message 'no sessions found'
        fi
      }

      _zellij_layouts() {
        local -a layouts
        layouts=(default compact development funfind)
        _describe 'layouts' layouts
      }

      _zellij() {
        local -a commands
        commands=(
          'attach:Attach to a session'
          'list-sessions:List existing sessions'
          'kill-session:Kill a specific session'
          'kill-all-sessions:Kill all sessions'
          'run:Run a command in a new pane'
          'edit:Edit a file in a new pane'
          'action:Perform an action'
          'setup:Setup zellij configuration'
          'convert-config:Convert configuration file'
          'convert-layout:Convert layout file'
          'convert-theme:Convert theme file'
        )

        if (( CURRENT == 2 )); then
          _describe 'command' commands
        else
          case $words[2] in
            attach)
              _zellij_sessions
              ;;
            kill-session)
              _zellij_sessions
              ;;
            --layout)
              _zellij_layouts
              ;;
            *)
              _files
              ;;
          esac
        fi
      }

      # Register completions
      compdef _zellij zellij
      compdef _zellij zj
      
      # Specific completions for aliases
      compdef _zellij_sessions 'zellij attach'
      compdef _zellij_sessions zja
      compdef _zellij_sessions zjk
      
      # Layout-specific aliases
      _zjd() { _arguments '--layout[Layout to use]:layout:_zellij_layouts' }
      _zjc() { _arguments '--layout[Layout to use]:layout:_zellij_layouts' }
      _zjf() { _arguments '--layout[Layout to use]:layout:_zellij_layouts' }
      
      compdef _zjd zjd
      compdef _zjc zjc
      compdef _zjf zjf

      # GitHub PR creation helper
      ghpr() {
        local title="$1"
        local body="$2"
        
        # Get current branch name
        local branch=$(git rev-parse --abbrev-ref HEAD)
        
        # Get the base branch (usually main or master)
        local base=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")
        
        if [ -z "$title" ]; then
          # Generate title from branch name or last commit
          title=$(git log -1 --pretty=format:"%s")
        fi
        
        if [ -z "$body" ]; then
          # Generate body from commit messages since base branch
          body=$(git log $base..$branch --pretty=format:"- %s" --reverse)
          # If no commits found, use the last commit message body
          if [ -z "$body" ]; then
            body=$(git log -1 --pretty=format:"%b")
          fi
        fi
        
        # Create PR
        gh pr create --base "$base" --head "$branch" --title "$title" --body "$body"
      }
    '';
  };
}
