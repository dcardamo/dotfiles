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
  home.sessionVariables = {
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    HOMEBREW_NO_ANALYTICS = "1";
    CARGO_NET_GIT_FETCH_WITH_CLI = "true";
    GOPATH = "$HOME/go";
    GIT_MERGE_AUTOEDIT = "no";
    NEXT_TELEMETRY_DISABLED = "1";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.packages = with pkgs;
    [thefuck tealdeer tokei cachix _1password]
    ++ lib.lists.optionals isLinux [xclip];

  programs.fish = {
    enable = true;

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
        gogit = "cd ~/git";
        "!!" = "eval \\$history[1]";
        ls = "${pkgs.lsd}/bin/lsd --group-directories-first";
        la = "ls -a";
        ll = "ls -l --git";
        l = "ls -laH";
        lg = "ls -lG";
        vi = "nvim";
        clear = "clear && _prompt_move_to_bottom";
        # Mac gaming FPS graph
        fps_on = "launchctl setenv MTL_HUD_ENABLED 1";
        fps_off = "launchctl setenv MTL_HUD_ENABLED 0";
        nix-apply =
          if pkgs.stdenv.isDarwin
          then "home-manager switch --flake ~/git/dotfiles/.#mac"
          else "sudo nixos-rebuild switch --flake ~/git/dotfiles/.#pc";
        oplocal = "./js/oph/dist/mac-arm64/1Password.app/Contents/MacOS/1Password";
      }
      // pkgs.lib.optionalAttrs isLinux {
        cfgnix = "sudo nvim /etc/nixos/configuration.nix";
        restart-gui = "sudo systemctl restart display-manager.service";
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
        fish_vi_key_bindings
        bind -M insert jk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char force-repaint; end"

        # abbreviations auto expand
        abbr -a --position anywhere -- R "| rg "

        # setup direnv
        direnv hook fish | source

        # I like to keep the prompt at the bottom rather than the top
        # of the terminal window so that running `clear` doesn't make
        # me move my eyes from the bottom back to the top of the screen;
        # keep the prompt consistently at the bottom
        _prompt_move_to_bottom # call function manually to load it since event handlers don't get autoloaded
      ''
      + lib.strings.optionalString isDarwin ''
        fish_add_path /opt/homebrew/bin
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
            echo -e ""
            echo -e "      \e[1m\e[38;5;112m\^V//"
            echo -e "      \e[38;5;184m|\e[37m· ·\e[38;5;184m|      \e[94mI AM GROOT !"
            echo -e "    \e[38;5;112m- \e[38;5;184m\ - /"
            echo -e "     \_| |_/\e[38;5;112m¯"
            echo -e "       \e[38;5;184m\ \\"
            echo -e "     \e[38;5;124m__\e[38;5;184m/\e[38;5;124m_\e[38;5;184m/\e[38;5;124m__"
            echo -e "    |_______|"
            echo -e "     \     /"
            echo -e "      \___/\e[39m\e[00m"
            echo -e ""
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
      photos-backup-first-run = {
        description = "Backup the Mac Photos library original files to external USB.  Use this for the first run";
        body = ''
          osxphotos export --export-by-date --download-missing --use-photokit --exiftool --library ~/Pictures/Photos Library.photoslibrary /Volumes/DanPhotoOriginal/osxphotos_export
        '';
      };
      photos-backup = {
        description = "Backup the Mac Photos library original files to external USB.  Use this for the update runs";
        body = ''
          osxphotos export --export-by-date --download-missing --use-photokit --exiftool --update --library ~/Pictures/Photos Library.photoslibrary /Volumes/DanPhotoOriginal/osxphotos_export
        '';
      };
    };
  };
}
