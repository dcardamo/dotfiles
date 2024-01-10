{
  home.sessionVariables = {
    MANPAGER = "nvim -c 'Man!' -o -";
  };

  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin.enable = true;
    #colorschemes.ayu.enable = true;

    globals = {
      mapleader = " ";
      loaded_ruby_provider = 0;
      loaded_perl_provider = 0;
      loaded_python_provider = 0;
    };
    maps = {
      normal = {
        "<leader>q" = {
          desc = "Quit NeoVim";
          action = "<cmd>qa<CR>";
        };
        "<leader>w" = {
          desc = "Save Current Buffer";
          action = "<cmd>w<CR>";
        };

        "<C-h>" = {
          action = "<C-w>h";
        };
        "<C-j>" = {
          action = "<C-w>j";
        };
        "<C-k>" = {
          action = "<C-w>k";
        };
        "<C-l>" = {
          action = "<C-w>l";
        };
        "<C-t>" = {
          desc = "Toggle Tree";
          action = "<cmd>lua require('nvim-tree.api').tree.toggle()<CR>";
        };
        "<leader>t" = {
          desc = "Trouble Toggle";
          action = ":TroubleToggle<CR>";
        };
        # Git signs mappings
        "<leader>gd" = {
          desc = "Git Diff";
          action = "<cmd>lua require('gitsigns').diffthis()<CR>";
        };
        "<leader>gr" = {
          desc = "Git Refresh";
          action = "<cmd>lua require('gitsigns').refresh()<CR>";
        };
        "<leader>gb" = {
          desc = "Git Blame";
          action = "<cmd>lua require('gitsigns').blame_line()<CR>";
        };
        "<leader>ghv" = {
          desc = "Git Hunk Visual Select";
          action = "<cmd>lua require('gitsigns').select_hunk()<CR>";
        };
        "<leader>ghp" = {
          desc = "Git Hunk Preview";
          action = "<cmd>lua require('gitsigns').preview_hunk()<CR>";
        };
        "<leader>ghr" = {
          desc = "Git Hunk Reset";
          action = "<cmd>lua require('gitsigns').reset_hunk()<CR>";
        };
        "<leader>ghs" = {
          desc = "Git Hunk Stage";
          action = "<cmd>lua require('gitsigns').stage_hunk()<CR>";
        };
        "<leader>ghu" = {
          desc = "Git Hunk Undo Stage";
          action = "<cmd>lua require('gitsigns').undo_stage_hunk()<CR>";
        };
        "<leader>gs" = {
          action = ":Neogit<CR>";
        };
        # end git signs mappings
        # LSP -- Start
        "<leader>ll" = {
          desc = "Toggle Lines";
          action = "<cmd>lua require('lsp_lines').toggle()<CR>";
        };
        "<leader>la" = {
          silent = true;
          desc = "Lsp Code Actions";
          action = "<cmd>Lspsaga code_action<CR>";
        };
        "<leader>lf" = {
          silent = true;
          desc = "Lsp Find";
          action = "<cmd>Lspsaga finder<CR>";
        };
        "<leader>lh" = {
          silent = true;
          desc = "Lsp Hover";
          action = "<cmd>Lspsaga hover_doc<CR>";
        };
        "<leader>lr" = {
          silent = true;
          desc = "Lsp Rename";
          action = "<cmd>Lspsaga rename<CR>";
        };
        "<leader>lp" = {
          silent = true;
          desc = "Lsp Show Definition";
          action = "<cmd>Lspsaga peek_definition<CR>";
        };
        "<leader>ld" = {
          silent = true;
          desc = "Lsp Goto Definition";
          action = "<cmd>Lspsaga goto_definition<CR>";
        };
        # LSP -- END
        # Telescope -- Start
        "<leader>ff" = {
          desc = "Find Files";
          action = "<cmd>lua require('telescope.builtin').find_files({hidden = true})<CR>";
        };
        "<leader>fg" = {
          desc = "Grep Files";
          action = "<cmd>lua require('telescope.builtin').live_grep({hidden = true})<CR>";
        };
        "<leader>fb" = {
          desc = "Find Buffer";
          action = "<cmd>lua require('telescope.builtin').buffers()<CR>";
        };
        "<leader>fh" = {
          desc = "Find Help";
          action = "<cmd>lua require('telescope.builtin').help_tags()<CR>";
        };
        "<leader>fd" = {
          desc = "Find Diagnostics";
          action = "<cmd>lua require('telescope.builtin').diagnostics()<CR>";
        };
        "<leader>ft" = {
          desc = "Find Treesitter";
          action = "<cmd>lua require('telescope.builtin').treesitter()<CR>";
        };
        # Telescope -- End
        # Noice -- Start
        # "<leader>c" = {
        #   desc = "Clear Messages";
        #   action = "<cmd>lua require('noice').cmd('dismiss')<CR>";
        # };
        # "<leader>fm" = {
        #   desc = "Find Messages";
        #   action = "<cmd>lua require('noice').cmd('telescope')<CR>";
        # };
        # Noice -- End
      };
      insert = {
        "jk" = {
          desc = "Esc";
          action = "<Esc>";
        };
      };
    };
    clipboard = {
      register = "unnamedplus";
    };
    options = {
      swapfile = false;
      autoindent = true;
      expandtab = true;
      hidden = true;
      ignorecase = true;
      incsearch = true;
      list = true;
      listchars = "tab:>-,trail:●,nbsp:+";
      number = true;
      relativenumber = true;
      scrolloff = 15;
      shiftwidth = 4;
      signcolumn = "yes";
      smartcase = true;
      softtabstop = 4;
      spell = true;
      splitbelow = true;
      splitright = true;
      tabstop = 4;
      termguicolors = true;
      updatetime = 100;
    };
    autoCmd = [
      {
        event = "FileType";
        pattern = "nix";
        command = "setlocal tabstop=2 shiftwidth=2 softtabstop=2";
      }
      {
        event = "VimEnter";
        command = "lua require('lsp_lines').toggle()";
      }
    ];
    plugins = {
      which-key.enable = true;
      nvim-autopairs.enable = true;
      comment-nvim.enable = true;
      tmux-navigator = {
        enable = true;
      };
      gitsigns = {
        enable = true;
        currentLineBlame = false;
      };
      alpha.enable = true;
      nvim-tree = {
        enable = true;
        git = {
          enable = true;
          ignore = false;
        };
        renderer.indentWidth = 1;
        diagnostics.enable = true;
        view.float.enable = true;
        updateFocusedFile.enable = true;
      };
      # LSP plugins
      lsp = {
        enable = true;
        servers = {
          lua-ls.enable = true;
          nil_ls.enable = true;
          yamlls.enable = true;
          bashls.enable = true;
          pylsp = {
            enable = true;
            settings = {
              plugins = {
                autopep8.enabled = false;
                black.enabled = false;
                flake8.enabled = false;
                mccabe.enabled = false;
                memestra.enabled = false;
                pycodestyle.enabled = false;
                pydocstyle.enabled = false;
                isort.enabled = true;
                pyflakes.enabled = false;
                pylint.enabled = false;
                pylsp_mypy.enabled = true;
                yapf.enabled = false;
              };
            };
          };
        };
      };
      lspkind = {
        enable = true;
      };
      rust-tools = {
        enable = true;
        server.check.command = "clippy";
      };
      null-ls = {
        enable = true;
        sources = {
          diagnostics = {
            shellcheck.enable = true;
            # vale.enable = true;
            # alex.enable = true;
            gitlint.enable = true;
            # protolint.enable = true;
            # hadolint.enable = true;
            # luacheck.enable = true;
            # mypy.enable = true;
            # yamllint.enable = true;
            # eslint_d.enable = true;
            deadnix.enable = true;
            statix.enable = true;
          };
          formatting = {
            # isort.enable = true;
            # taplo.enable = true;
            # jq.enable = true;
            stylua.enable = true;
            # markdownlint.enable = true;
            prettier.enable = true;
            # rustfmt.enable = true;
            black.enable = true;
            # clang_format.enable = true;
            # sqlfluff.enable = true;
          };
        };
      };
      lsp-lines.enable = true;
      #nvim-lightbulb.enable = true;
      lspsaga = {
        enable = false;
        # use this when upgrade to 23.11
        # extraOptions = {
        #   icons.codeAction = null; # hide the lightbulb icon, annoying
        # };
      };
      luasnip.enable = true;
      neogit.enable = true;
      #diffview.enable = true;
      nvim-cmp = {
        enable = true;
        sources = [
          {name = "path";}
          {name = "nvim_lsp";}
          {name = "luasnip";}
          {name = "crates";}
          {name = "buffer";}
        ];
        mapping = {
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = {
            action = "cmp.mapping.select_next_item()";
            modes = ["i" "s"];
          };
          "<S-Tab>" = {
            action = "cmp.mapping.select_prev_item()";
            modes = ["i" "s"];
          };
        };
        snippet.expand = "luasnip";
      };
      # end LSP plugins
      # LUA Line Start
      lualine = {
        enable = true;
        theme = "catppuccin";
        componentSeparators = {
          left = "";
          right = "";
        };
        sectionSeparators = {
          left = "";
          right = "";
        };
        sections = {
          lualine_c = [
            {
              name = "filename";
              extraConfig = {
                path = 1;
              };
            }
          ];
        };
      };
      # LUA Line End
      trouble.enable = true;
      crates-nvim.enable = true;
      undotree.enable = true;
      telescope = {
        enable = true;
        defaults = {
          file_ignore_patterns = [
            "^.git/"
            "^output/"
            "^target/"
          ];
        };
      };
      treesitter = {
        enable = true;
        indent = false;
        nixvimInjections = true;
      };
      treesitter-context.enable = true;
      indent-blankline = {
        enable = true;
        char = "";
        showCurrentContext = false;
      };
      lastplace.enable = true;
      # noice = {
      #   enable = true;
      #   notify.enabled = true;
      #   lsp = {
      #     override = {
      #       "vim.lsp.util.convert_input_to_markdown_lines" = true;
      #       "vim.lsp.util.stylize_markdown" = true;
      #       "cmp.entry.get_documentation" = true;
      #     };
      #     progress.enabled = false;
      #   };
      # };
      # notify = {
      #   enable = true;
      #   backgroundColour = "#000000";
      # };
    };
  };
}
