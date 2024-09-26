{pkgs, ...}: {
  home.packages = with pkgs; [
    bash-language-server
    biome
    clang-tools
    docker-compose-language-service
    dockerfile-language-server-nodejs
    golangci-lint
    golangci-lint-langserver
    gopls
    gotools
    helix-gpt
    marksman
    nil
    alejandra
    nodePackages.prettier
    nodePackages.typescript-language-server
    pgformatter
    (python3.withPackages
      (p: (with p; [black isort python-lsp-black python-lsp-server])))
    rust-analyzer
    taplo
    taplo-lsp
    # terraform-ls
    typescript
    vscode-langservers-extracted
    yaml-language-server
    elixir-ls
  ];
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
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
# Old config not used
/*
comment out vim like stuff for normal mode

       # quit iteration on config changes
       "C-o" = ":config-open";
       "C-r" = ":config-reload";

       # some nice helix stuff
       "C-h" = "select_prev_sibling";
       "C-j" = "shrink_selection";
       "C-k" = "expand_selection";
       "C-l" = "select_next_sibling";

       #personal preference
       "o" = [ "open_below" "normal_mode" ];
       "O" = [ "open_above" "normal_mode" ];

       # muscle memory
       "{" = [ "goto_prev_paragraph" "collapse_selection" ];
       "}" = [ "goto_next_paragraph" "collapse_selection" ];
       "0" = "goto_line_start";
       "$" = "goto_line_end";
       "^" = "goto_first_nonwhitespace";
       "G" = "goto_file_end";
       "%" = "match_brackets";
       "V" = [ "select_mode" "extend_to_line_bounds" ];
       "C" = [
         "extend_to_line_end"
         "yank_main_selection_to_clipboard"
         "delete_selection"
         "insert_mode"
       ];
       "D" = [
         "extend_to_line_end"
         "yank_main_selection_to_clipboard"
         "delete_selection"
       ];
       "S" = "surround_add";

       #clipboards over registers ye ye
       "x" = "delete_selection";
       "p" = [ "paste_clipboard_after" "collapse_selection" ];
       "P" = [ "paste_clipboard_before" "collapse_selection" ];
       "Y" = [
         "extend_to_line_end"
         "yank_main_selection_to_clipboard"
         "collapse_selection"
       ];

       # this makes w and b behave as they do in vim
       "w" =
         [ "move_next_word_start" "move_char_right" "collapse_selection" ];
       "W" = [
         "move_next_long_word_start"
         "move_char_right"
         "collapse_selection"
       ];
       "e" = [ "move_next_word_end" "collapse_selection" ];
       "E" = [ "move_next_long_word_end" "collapse_selection" ];
       "b" = [ "move_prev_word_start" "collapse_selection" ];
       "B" = [ "move_prev_long_word_start" "collapse_selection" ];

       # If you want to keep the selection-while-moving behaviour of Helix, this two lines will help a lot,
       # especially if you find having text remain selected while you have switched to insert or append mode
       #
       # There is no real difference if you have overridden the commands bound to 'w', 'e' and 'b' like above
       # But if you really want to get familiar with the Helix way of selecting-while-moving, comment the
       # bindings for 'w', 'e', and 'b' out and leave the bindings for 'i' and 'a' active below. A world of difference!
       "i" = [ "insert_mode" "collapse_selection" ];
       "a" = [ "append_mode" "collapse_selection" ];

       # Undoing the 'd' + motion commands restores the selection which is annoying
       "u" = [ "undo" "collapse_selection" ];

       # Escape the madness! No more fighting with the cursor! Or with multiple cursors!
       esc = [ "collapse_selection" "keep_primary_selection" ];

       # Search for word under cursor
       "*" = [
         "move_char_right"
         "move_prev_word_start"
         "move_next_word_end"
         "search_selection"
         "search_next"
       ];
       "#" = [
         "move_char_right"
         "move_prev_word_start"
         "move_next_word_end"
         "search_selection"
         "search_prev"
       ];

       # Make j and k behave as they do Vim when soft-wrap is enabled
       "j" = "move_line_down";
       "k" = "move_line_up";

       # Extend and select commands that expect a manual input can't be chained
       # I've kept d[X] commands here because it's better to at least have the stuff you want to delete
       # selected so that it's just a keystroke away to delete
       d = {
         "d" = [
           "extend_to_line_bounds"
           "yank_main_selection_to_clipboard"
           "delete_selection"
         ];
         "t" = [ "extend_till_char" ];
         "s" = [ "surround_delete" ];
         "i" = [ "select_textobject_inner" ];
         "a" = [ "select_textobject_around" ];
         "j" = [
           "select_mode"
           "extend_to_line_bounds"
           "extend_line_below"
           "yank_main_selection_to_clipboard"
           "delete_selection"
           "normal_mode"
         ];
         down = [
           "select_mode"
           "extend_to_line_bounds"
           "extend_line_below"
           "yank_main_selection_to_clipboard"
           "delete_selection"
           "normal_mode"
         ];
         "k" = [
           "select_mode"
           "extend_to_line_bounds"
           "extend_line_above"
           "yank_main_selection_to_clipboard"
           "delete_selection"
           "normal_mode"
         ];
         up = [
           "select_mode"
           "extend_to_line_bounds"
           "extend_line_above"
           "yank_main_selection_to_clipboard"
           "delete_selection"
           "normal_mode"
         ];
         "G" = [
           "select_mode"
           "extend_to_line_bounds"
           "goto_last_line"
           "extend_to_line_bounds"
           "yank_main_selection_to_clipboard"
           "delete_selection"
           "normal_mode"
         ];
         "w" = [
           "move_next_word_start"
           "yank_main_selection_to_clipboard"
           "delete_selection"
         ];
         "W" = [
           "move_next_long_word_start"
           "yank_main_selection_to_clipboard"
           "delete_selection"
         ];
         "g" = {
           "g" = [
             "select_mode"
             "extend_to_line_bounds"
             "goto_file_start"
             "extend_to_line_bounds"
             "yank_main_selection_to_clipboard"
             "delete_selection"
             "normal_mode"
           ];
         };
       };
       y = {
         "y" = [
           "extend_to_line_bounds"
           "yank_main_selection_to_clipboard"
           "normal_mode"
           "collapse_selection"
         ];
         "j" = [
           "select_mode"
           "extend_to_line_bounds"
           "extend_line_below"
           "yank_main_selection_to_clipboard"
           "collapse_selection"
           "normal_mode"
         ];
         down = [
           "select_mode"
           "extend_to_line_bounds"
           "extend_line_below"
           "yank_main_selection_to_clipboard"
           "collapse_selection"
           "normal_mode"
         ];
         "k" = [
           "select_mode"
           "extend_to_line_bounds"
           "extend_line_above"
           "yank_main_selection_to_clipboard"
           "collapse_selection"
           "normal_mode"
         ];
         up = [
           "select_mode"
           "extend_to_line_bounds"
           "extend_line_above"
           "yank_main_selection_to_clipboard"
           "collapse_selection"
           "normal_mode"
         ];
         "G" = [
           "select_mode"
           "extend_to_line_bounds"
           "goto_last_line"
           "extend_to_line_bounds"
           "yank_main_selection_to_clipboard"
           "collapse_selection"
           "normal_mode"
         ];
         "w" = [
           "move_next_word_start"
           "yank_main_selection_to_clipboard"
           "collapse_selection"
           "normal_mode"
         ];
         "W" = [
           "move_next_long_word_start"
           "yank_main_selection_to_clipboard"
           "collapse_selection"
           "normal_mode"
         ];
         "g" = {
           "g" = [
             "select_mode"
             "extend_to_line_bounds"
             "goto_file_start"
             "extend_to_line_bounds"
             "yank_main_selection_to_clipboard"
             "collapse_selection"
             "normal_mode"
           ];
         };
       };
*/
/*
comment out vim like stuff
     select = {
       # Muscle memory
       "{" = [ "extend_to_line_bounds" "goto_prev_paragraph" ];
       "}" = [ "extend_to_line_bounds" "goto_next_paragraph" ];
       "0" = "goto_line_start";
       "$" = "goto_line_end";
       "^" = "goto_first_nonwhitespace";
       "G" = "goto_file_end";
       "D" = [ "extend_to_line_bounds" "delete_selection" "normal_mode" ];
       "C" =
         [ "goto_line_start" "extend_to_line_bounds" "change_selection" ];
       "%" = "match_brackets";
       "S" = "surround_add"; # Basically 99% of what I use vim-surround for
       "u" = [ "switch_to_lowercase" "collapse_selection" "normal_mode" ];
       "U" = [ "switch_to_uppercase" "collapse_selection" "normal_mode" ];

       # Visual-mode specific muscle memory
       "i" = "select_textobject_inner";
       "a" = "select_textobject_around";

       # Some extra binds to allow us to insert/append in select mode because it's nice with multiple cursors
       tab = [
         "insert_mode"
         "collapse_selection"
       ]; # tab is read by most terminal editors as "C-i"
       "C-a" = [ "append_mode" "collapse_selection" ];

       # Make selecting lines in visual mode behave sensibly
       "k" = [ "extend_line_up" "extend_to_line_bounds" ];
       "j" = [ "extend_line_down" "extend_to_line_bounds" ];

       # Clipboards over registers ye ye
       "d" = [ "yank_main_selection_to_clipboard" "delete_selection" ];
       "x" = [ "yank_main_selection_to_clipboard" "delete_selection" ];
       "y" = [
         "yank_main_selection_to_clipboard"
         "normal_mode"
         "flip_selections"
         "collapse_selection"
       ];
       "Y" = [
         "extend_to_line_bounds"
         "yank_main_selection_to_clipboard"
         "goto_line_start"
         "collapse_selection"
         "normal_mode"
       ];
       "p" = "replace_selections_with_clipboard"; # No life without this
       "P" = "paste_clipboard_before";

       # Escape the madness! No more fighting with the cursor! Or with multiple cursors!
       esc = [ "collapse_selection" "keep_primary_selection" "normal_mode" ];
     };
*/
