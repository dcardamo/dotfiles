{
  pkgs,
  lib,
  vars,
  ...
}:
let
  inherit (pkgs) stdenv;
  inherit (stdenv) isLinux;
  inherit (stdenv) isDarwin;
in
{
  home.packages =
    with pkgs;
    [
      tealdeer
      tokei
    ]
    ++ lib.lists.optionals isLinux [ ];

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
      EDITOR = "hx";
      VISUAL = "hx";
      GIT_EDITOR = "hx";
      COLORTERM = "truecolor";
      NIXPKGS_ALLOW_UNFREE = 1;
      NPM_CONFIG_PREFIX = "$HOME/.npm-global";
      # Add Nix profile to PATH for non-interactive sessions
      PATH = "$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH";
    };

    shellAliases =
      {
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
        # Zellij tab naming shortcuts
        zt = "update_zellij_tab_name";
        ztn = "zellij action rename-tab";
      }
      // pkgs.lib.optionalAttrs isLinux {
        cfgnix = "sudo nvim /etc/nixos/configuration.nix";
        restart-gui = "sudo systemctl restart display-manager.service";
        nixsearch = "nix search nixpkgs";
      };

    # initContent runs for interactive shells
    initContent =
      ''
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
      ''
      + ''
        export PROMPT_DIRTRIM=3

        # Enable direnv
        eval "$(direnv hook zsh)"

        # Zellij tab naming with git branch support
        update_zellij_tab_name() {
          if [ -n "$ZELLIJ" ]; then
            local tab_name=""
            local dir_name=""
            local branch=""

            # Get git branch if in a git repo
            if git rev-parse --git-dir > /dev/null 2>&1; then
              # Get git repository root directory name
              local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
              if [ -n "$git_root" ]; then
                # Check if we're in a git worktree
                local git_dir=$(git rev-parse --git-dir 2>/dev/null)
                if [[ "$git_dir" == *"/worktrees/"* ]]; then
                  # We're in a worktree, find the main repository
                  # Extract main repo path from worktree git-dir
                  local main_git_dir=$(echo "$git_dir" | sed 's|/worktrees/.*||')
                  local main_repo_root=$(dirname "$main_git_dir")

                  # Check if main repo ends with /index or /main, use parent dir
                  if [[ "$main_repo_root" == */index ]] || [[ "$main_repo_root" == */main ]]; then
                    dir_name=$(basename "$(dirname "$main_repo_root")")
                  else
                    dir_name=$(basename "$main_repo_root")
                  fi
                else
                  # Regular git repo (not a worktree)
                  if [[ "$git_root" == */index ]] || [[ "$git_root" == */main ]]; then
                    dir_name=$(basename "$(dirname "$git_root")")
                  else
                    dir_name=$(basename "$git_root")
                  fi
                fi
              else
                dir_name=$(basename "$PWD")
              fi

              branch=$(git branch --show-current 2>/dev/null)
              if [ -n "$branch" ]; then
                tab_name="$dir_name [$branch]"
              else
                tab_name="$dir_name"
              fi
            else
              # Not in a git repo, use current directory name
              dir_name=$(basename "$PWD")
              tab_name="$dir_name"
            fi

            # Update Zellij tab name
            command zellij action rename-tab "$tab_name" > /dev/null 2>&1
          fi
        }

        # Auto-update tab name on directory change
        chpwd() {
          update_zellij_tab_name
        }

        # Auto-update tab name on git branch change
        precmd() {
          update_zellij_tab_name
        }

        # Manual tab naming command
        zellij_name_tab() {
          if [ -n "$ZELLIJ" ]; then
            if [ -n "$1" ]; then
              command zellij action rename-tab "$1"
            else
              echo "Usage: zellij_name_tab <tab_name>"
            fi
          else
            echo "Not in a Zellij session"
          fi
        }
        alias ztn="zellij_name_tab"

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

        # AI assistant function
        ai() {
          if [[ -f /.dockerenv ]] || [[ -n "$CONTAINER_ID" ]]; then
            # In Docker container, use claude directly
            claude --dangerously-skip-permissions "$@"
          else
            # On Mac, use claude-mac-sandbox
            claude-mac-sandbox run --dangerously-skip-permissions "$@"
          fi
        }

        # Custom prompt setup
        autoload -U colors && colors

        # Set up the prompt - override oh-my-zsh theme
        setopt PROMPT_SUBST
        
        # Unset oh-my-zsh's git functions to avoid conflicts
        unfunction git_prompt_info 2>/dev/null || true
        unfunction git_prompt_status 2>/dev/null || true

        # Function to get system icon
        function get_system_icon() {
          if [[ -f /.dockerenv ]] || [[ -n "$CONTAINER_ID" ]]; then
            echo "🐳"
          elif [[ "$OSTYPE" == "darwin"* ]]; then
            echo $'\ue711' # nf-dev-apple
          else
            echo "🐧"
          fi
        }

        # Function to get git info
        function git_prompt_info() {
          if git rev-parse --git-dir > /dev/null 2>&1; then
            local branch=$(git branch --show-current 2>/dev/null || echo "detached")
            # Using nf-dev-git_branch icon
            echo " %{$fg_bold[magenta]%}\ue725 $branch%{$reset_color%}"
          fi
        }

        # Function to get git status
        function git_prompt_status() {
          if git rev-parse --git-dir > /dev/null 2>&1; then
            local git_status=""
            local has_changes=false
            
            # Check for various git states
            git diff --quiet || { git_status+="!"; has_changes=true; }
            git diff --cached --quiet || { git_status+="+"; has_changes=true; }
            [[ -n $(git ls-files --others --exclude-standard) ]] && { git_status+="?"; has_changes=true; }
            
            # Check if we're ahead or behind
            local upstream=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
            if [[ -n "$upstream" ]]; then
              local ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null)
              local behind=$(git rev-list --count HEAD..@{u} 2>/dev/null)
              [[ "$ahead" -gt 0 ]] && git_status+="⇡$ahead"
              [[ "$behind" -gt 0 ]] && git_status+="⇣$behind"
              [[ "$ahead" -gt 0 || "$behind" -gt 0 ]] && has_changes=true
            fi
            
            if [[ "$has_changes" == true ]]; then
              echo " %{$fg[yellow]%}[$git_status]%{$reset_color%}"
            fi
          fi
        }
        
        # Define our custom prompt
        PROMPT='$(get_system_icon) %{$fg[cyan]%}%m%{$reset_color%} %{$fg[blue]%}%~%{$reset_color%}$(git_prompt_info)$(git_prompt_status)
%{$fg_bold[magenta]%}»%{$reset_color%} '
        
        # Disable oh-my-zsh's git prompt (if it exists)
        ZSH_THEME_GIT_PROMPT_PREFIX=""
        ZSH_THEME_GIT_PROMPT_SUFFIX=""
      '';
  };
}
