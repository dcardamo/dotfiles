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
  home.sessionVariables = {
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
  };

  home.packages =
    with pkgs;
    [
      tealdeer
      tokei
    ]
    ++ lib.lists.optionals isLinux [ ];

  programs.fish = {
    enable = false;

    plugins = [
      {
        name = "foreign-env";
        inherit (pkgs.fishPlugins.foreign-env) src;
      }
    ];

    shellAliases =
      {
        copy = vars.copyCmd;
        paste = vars.pasteCmd;
        cat = "bat";
        "!!" = "eval \\$history[1]";
        ls = "${pkgs.lsd}/bin/lsd --group-directories-first";
        la = "ls -a";
        ll = "ls -l --git";
        l = "ls -laH";
        lg = "ls -lG";
        df = "duf";
        # Take away muscle memory:  vi = "nvim";
        e = "hx";
        tar = "tar --use-compress-program='pigz -p 24'";
        clear = "clear && _prompt_move_to_bottom";
        # Mac gaming FPS graph
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
        nixsearch = "nix search nixpkgs"; # search for a package
      };

    shellInit = ''
      set -g fish_prompt_pwd_dir_length 20

      # Source nix files, required to set fish as default shell, otherwise
      # it doesn't have the nix env vars
      if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]
        fenv source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
      end
    '';

    interactiveShellInit =
      ''
        # Setup our editor:
        if set -q ZED_TERM
            set GIT_EDITOR "zed --wait"
            set EDITOR "zed --wait"
            set VISUAL "zed --wait"
        else
            set EDITOR hx
            set VISUAL hx
            set GIT_EDITOR hx;
        end
        #fish_vi_key_bindings
        #bind -M insert jk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char force-repaint; end"

        # abbreviations auto expand
        abbr -a --position anywhere -- R "| rg "

        # setup direnv
        direnv hook fish | source

        # I like to keep the prompt at the bottom rather than the top
        # of the terminal window so that running `clear` doesn't make
        # me move my eyes from the bottom back to the top of the screen;
        # keep the prompt consistently at the bottom
        _prompt_move_to_bottom # call function manually to load it since event handlers don't get autoloaded

        # npm install -g modules
        fish_add_path ~/.npm-global/bin

        # Auto-update Zellij tab name on directory change
        function __zellij_update_tab_name --on-variable PWD
            update_zellij_tab_name
        end

        # Auto-update on git operations
        function __zellij_update_tab_name_git --on-event fish_postexec
            if string match -q '*git*' -- (commandline -p)
                update_zellij_tab_name
            end
        end
      ''
      + lib.strings.optionalString isDarwin ''
        fish_add_path /opt/homebrew/bin
        fish_add_path ~/.local/bin
        fish_add_path ~/.orbstack/bin
      '';

    functions = {
      fish_greeting = "";
      _prompt_move_to_bottom = {
        onEvent = "fish_postexec";
        body = "tput cup $LINES";
      };
      nix-clean = ''
        nix-env --delete-generations old
        nix-store --gc
        nix-channel --update
        nix-env -u --always
        if test -f /etc/NIXOS
            for link in /nix/var/nix/gcroots/auto/*
                rm $(readlink "$link")
            end
        end
        nix-collect-garbage -d
      '';
      groot = {
        description = "cd to the root of the current git repository";
        body = ''
          set -l git_repo_root_dir (git rev-parse --show-toplevel 2>/dev/null)
          if test -n "$git_repo_root_dir"
            cd "$git_repo_root_dir"
          else
            echo "Not in a git repository."
          end
        '';
      };
      nix-shell = {
        wraps = "nix-shell";
        body = ''
          for ARG in $argv
            if [ "$ARG" = --run ]
              command nix-shell $argv
              return $status
            end
          end
          command nix-shell $argv --run "exec fish"
        '';
      };
      update_zellij_tab_name = {
        description = "Update Zellij tab name with current directory and git branch";
        body = ''
          if test -n "$ZELLIJ"
            set -l tab_name ""
            set -l dir_name ""
            set -l branch ""

            # Get git branch if in a git repo
            if git rev-parse --git-dir >/dev/null 2>&1
              # Get git repository root directory name
              set -l git_root (git rev-parse --show-toplevel 2>/dev/null)
              if test -n "$git_root"
                # Check if we're in a git worktree
                set -l git_dir (git rev-parse --git-dir 2>/dev/null)
                if string match -q "*/worktrees/*" "$git_dir"
                  # We're in a worktree, find the main repository
                  # Extract main repo path from worktree git-dir
                  set -l main_git_dir (string replace -r "/worktrees/.*" "" "$git_dir")
                  set -l main_repo_root (dirname "$main_git_dir")

                  # Check if main repo ends with /index or /main, use parent dir
                  if string match -q "*/index" "$main_repo_root"; or string match -q "*/main" "$main_repo_root"
                    set dir_name (basename (dirname "$main_repo_root"))
                  else
                    set dir_name (basename "$main_repo_root")
                  end
                else
                  # Regular git repo (not a worktree)
                  if string match -q "*/index" "$git_root"; or string match -q "*/main" "$git_root"
                    set dir_name (basename (dirname "$git_root"))
                  else
                    set dir_name (basename "$git_root")
                  end
                end
              else
                set dir_name (basename $PWD)
              end

              set branch (git branch --show-current 2>/dev/null)
              if test -n "$branch"
                set tab_name "$dir_name [$branch]"
              else
                set tab_name "$dir_name"
              end
            else
              # Not in a git repo, use current directory name
              set dir_name (basename $PWD)
              set tab_name "$dir_name"
            end

            # Update Zellij tab name
            command zellij action rename-tab "$tab_name" >/dev/null 2>&1
          end
        '';
      };
      ztn = {
        description = "Rename Zellij tab manually";
        body = ''
          if test -n "$ZELLIJ"
            if test -n "$argv[1]"
              command zellij action rename-tab "$argv[1]"
            else
              echo "Usage: ztn <tab_name>"
            end
          else
            echo "Not in a Zellij session"
          end
        '';
      };
    };
  };
}
