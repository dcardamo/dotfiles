{pkgs, ...}: {
  home.packages = with pkgs; [
    biome
    helix-gpt
    marksman
    nil
    taplo
    taplo-lsp
    # terraform-ls
    vscode-langservers-extracted

    # evil-helix
  ];
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      evil = true; # use vim keybindings
      theme = "tokyonight_moon";
      editor = {
        color-modes = true;
        cursorline = true;
        bufferline = "multiple";
        auto-save = {
          focus-lost = true;
          after-delay.enable = true;
        };
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        file-picker = {
          hidden = false;
          ignore = false;
        };
        indent-guides = {
          character = "┊";
          render = true;
          skip-levels = 1;
        };
        lsp = {
          display-inlay-hints = true;
          display-messages = true;
        };

        statusline = {
          left = [
            "mode"
            "file-name"
            "spinner"
            "read-only-indicator"
            "file-modification-indicator"
          ];
          right = [
            "diagnostics"
            "selections"
            "register"
            "file-type"
            "file-line-ending"
            "position"
          ];
          mode.normal = "󰅬";
          mode.insert = "";
          mode.select = "󰫙";
        };
      };
      keys = {
        # insert = { esc = [ "collapse_selection" "normal_mode" ]; };
        insert = {
          C-e = "insert_at_line_end";
          C-f = "move_char_right";
          C-b = "move_char_left";
          # default keybinding.  Reminder its here instead of 'jj'
          # C-[ = "normal_mode";
        };

        normal = {
          C-e = "goto_line_end";
          Z = {
            Q = ":quit!";
            Z = ":x";
          };
          "0" = "goto_line_start";
          "$" = "goto_line_end";
          "%" = "match_brackets";
          G = "goto_file_end";
          D = "kill_to_line_end";
          # to allow natural movement while tmux swallows the CTRL versions of these keys
          A-h = "jump_view_left";
          A-j = "jump_view_down";
          A-k = "jump_view_up";
          A-l = "jump_view_right";
        };

        select = {G = "goto_file_end";};
      };
    };
    languages = {
      language = [
        {
          name = "css";
          language-servers = ["vscode-css-language-server" "gpt"];
          formatter = {
            command = "prettier";
            args = ["--stdin-filepath" "file.css"];
          };
          auto-format = true;
        }
        {
          name = "elixir";
          language-servers = ["elixir-ls"];
          auto-format = true;
        }
        {
          name = "go";
          language-servers = ["gopls" "golangci-lint-lsp" "gpt"];
          formatter = {command = "goimports";};
          auto-format = true;
        }
        {
          name = "html";
          language-servers = ["vscode-html-language-server" "gpt"];
          formatter = {
            command = "prettier";
            args = ["--stdin-filepath" "file.html"];
          };
          auto-format = true;
        }
        {
          name = "javascript";
          language-servers = [
            {
              name = "typescript-language-server";
              except-features = ["format"];
            }
            "biome"
            "gpt"
          ];
          auto-format = true;
        }
        {
          name = "json";
          language-servers = [
            {
              name = "vscode-json-language-server";
              except-features = ["format"];
            }
            "biome"
          ];
          formatter = {
            command = "biome";
            args = [
              "format"
              "--indent-style"
              "space"
              "--stdin-file-path"
              "file.json"
            ];
          };
          auto-format = true;
        }
        {
          name = "jsonc";
          language-servers = [
            {
              name = "vscode-json-language-server";
              except-features = ["format"];
            }
            "biome"
          ];
          formatter = {
            command = "biome";
            args = [
              "format"
              "--indent-style"
              "space"
              "--stdin-file-path"
              "file.jsonc"
            ];
          };
          file-types = ["jsonc" "hujson"];
          auto-format = true;
        }
        {
          name = "jsx";
          language-servers = [
            {
              name = "typescript-language-server";
              except-features = ["format"];
            }
            "biome"
            "gpt"
          ];
          formatter = {
            command = "biome";
            args = [
              "format"
              "--indent-style"
              "space"
              "--stdin-file-path"
              "file.jsx"
            ];
          };
          auto-format = true;
        }
        {
          name = "markdown";
          language-servers = ["marksman" "gpt"];
          formatter = {
            command = "prettier";
            args = ["--stdin-filepath" "file.md"];
          };
          auto-format = true;
        }
        {
          name = "nix";
          formatter.command = "${pkgs.alejandra}/bin/alejandra";
          auto-format = true;
        }
        {
          name = "python";
          language-servers = ["pylsp" "gpt"];
          formatter = {
            command = "sh";
            args = ["-c" "isort --profile black - | black -q -"];
          };
          auto-format = true;
        }
        {
          name = "rust";
          language-servers = ["rust-analyzer" "gpt"];
          auto-format = true;
        }
        {
          name = "scss";
          language-servers = ["vscode-css-language-server" "gpt"];
          formatter = {
            command = "prettier";
            args = ["--stdin-filepath" "file.scss"];
          };
          auto-format = true;
        }
        {
          name = "sql";
          language-servers = ["gpt"];
          formatter = {
            command = "pg_format";
            args = ["-iu1" "--no-space-function" "-"];
          };
          auto-format = true;
        }
        {
          name = "toml";
          language-servers = ["taplo"];
          formatter = {
            command = "taplo";
            args = ["fmt" "-o" "column_width=120" "-"];
          };
          auto-format = true;
        }
        {
          name = "tsx";
          language-servers = [
            {
              name = "typescript-language-server";
              except-features = ["format"];
            }
            "biome"
            "gpt"
          ];
          formatter = {
            command = "biome";
            args = [
              "format"
              "--indent-style"
              "space"
              "--stdin-file-path"
              "file.tsx"
            ];
          };
          auto-format = true;
        }
        {
          name = "typescript";
          language-servers = [
            {
              name = "typescript-language-server";
              except-features = ["format"];
            }
            "biome"
            "gpt"
          ];
          formatter = {
            command = "biome";
            args = [
              "format"
              "--indent-style"
              "space"
              "--stdin-file-path"
              "file.ts"
            ];
          };
          auto-format = true;
        }
        {
          name = "yaml";
          language-servers = ["yaml-language-server"];
          formatter = {
            command = "prettier";
            args = ["--stdin-filepath" "file.yaml"];
          };
          auto-format = true;
        }
      ];
      language-server.gpt = {
        command = "helix-gpt";
        args = ["--handler" "copilot"];
      };
      language-server.rust-analyzer.config.check = {command = "clippy";};
      language-server.yaml-language-server.config.yaml.schemas = {
        kubernetes = "k8s/*.yaml";
      };
      language-server.typescript-language-server.config.tsserver = {
        path = "${pkgs.typescript}/lib/node_modules/typescript/lib/tsserver.js";
      };
    };
  };
}
