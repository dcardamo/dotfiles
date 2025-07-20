{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    gitleaks
  ];

  programs.git = {
    enable = true;

    userName = "Dan Cardamore";
    userEmail = "dan@hld.ca";

    extraConfig = {
      advice.detachedHead = false;
      branch.autosetuprebase = "always";

      color = {
        branch = {
          current = "green reverse";
          local = "green";
          remote = "yellow";
        };

        status = {
          added = "green";
          changed = "yellow";
          untracked = "blue";
        };
      };

      core = {
        autocrlf = "input";
        untrackedCache = true;
      };

      diff = {
        colorMoved = "default";

        gpg = {
          binary = true;
          textconv = "${lib.getExe pkgs.gnupg} --decrypt --quiet --yes --compress-algo=none --no-encrypt-to --batch --use-agent";
        };
      };

      init.defaultBranch = "main";
      push.default = "current";

      rebase = {
        autostash = true;
        autosquash = true;
      };

      pull = {
        rebase = true;
      };

      user.useConfigOnly = true;
    };

    ignores = [
      ".direnv"
      "__pycache__"
      "node_modules"
      "*.log"
      ".DS_Store"
    ];

    lfs = {
      enable = true;
    };

    delta = {
      enable = true;
      options = {
        features = "hyperlinks";
        # file-added-label = "[+]";
        # file-copied-label = "[C]";
        # file-decoration-style = "yellow ul";
        # file-modified-label = "[M]";
        # file-removed-label = "[-]";
        # file-renamed-label = "[R]";
        # file-style = "yellow bold";
        # hunk-header-decoration-style = "omit";
        # hunk-header-style = "syntax italic #303030";
        # minus-emph-style = "syntax bold #780000";
        # minus-style = "syntax #400000";
        # plus-emph-style = "syntax bold #007800";
        # plus-style = "syntax #004000";
        syntax-theme = "gruvbox-dark";
        side-by-side = true;
        # width = 1;
      };
    };
  };
}
