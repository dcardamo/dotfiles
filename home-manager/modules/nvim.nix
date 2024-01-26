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
    keymaps = [
    {
      key = "<leader>q" ;
      options.desc = "Quit NeoVim";
      action = "<cmd>qa<CR>";
    }
    {
      key = "<leader>w";
      options.desc = "Save Current Buffer";
      action = "<cmd>w<CR>";
    }
    {
      key = "<C-h>";
      action = "<C-w>h";
    }
    {
      key = "<C-j>";
      action = "<C-w>j";
    }
    {
      key = "<C-k>";
      action = "<C-w>k";
    }
    {
      key = "<C-l>";
      action = "<C-w>l";
    }
    {
      key = "<C-t>";
      options.desc = "Toggle Tree";
      action = "<cmd>lua require('nvim-tree.api').tree.toggle()<CR>";
    }
    {
      key = "<leader>t";
      options.desc = "Trouble Toggle";
      action = ":TroubleToggle<CR>";
    }
    # Git signs mappings
    {
      key = "<leader>gd";
      options.desc = "Git Diff";
      action = "<cmd>lua require('gitsigns').diffthis()<CR>";
    }
    {
      key = "<leader>gr";
      options.desc = "Git Refresh";
      action = "<cmd>lua require('gitsigns').refresh()<CR>";
    }
    {
      key = "<leader>gb";
      options.desc = "Git Blame";
      action = "<cmd>lua require('gitsigns').blame_line()<CR>";
    }
    {
      key = "<leader>ghv";
      options.desc = "Git Hunk Visual Select";
      action = "<cmd>lua require('gitsigns').select_hunk()<CR>";
    }
    {
      key ="<leader>ghp";
      options.desc = "Git Hunk Preview";
      action = "<cmd>lua require('gitsigns').preview_hunk()<CR>";
    }
    {
      key = "<leader>ghr";
      options.desc = "Git Hunk Reset";
      action = "<cmd>lua require('gitsigns').reset_hunk()<CR>";
    }
    {
      key = "<leader>ghs";
      options.desc = "Git Hunk Stage";
      action = "<cmd>lua require('gitsigns').stage_hunk()<CR>";
    }
    {
      key = "<leader>ghu";
      options.desc = "Git Hunk Undo Stage";
      action = "<cmd>lua require('gitsigns').undo_stage_hunk()<CR>";
    }
    {
      key = "<leader>gs";
      action = ":Neogit<CR>";
    }
    # end git signs mappings
    # LSP -- Start
    {
      key = "<leader>ll";
      options.desc = "Toggle Lines";
      action = "<cmd>lua require('lsp_lines').toggle()<CR>";
    }
    {
      key = "<leader>la";
      options.silent = true;
      options.desc = "Lsp Code Actions";
      action = "<cmd>Lspsaga code_action<CR>";
    }
    {
      key = "<leader>lf";
      options.silent = true;
      options.desc = "Lsp Find";
      action = "<cmd>Lspsaga finder<CR>";
    }
    {
      key = "<leader>lh";
      options.silent = true;
      options.desc = "Lsp Hover";
      action = "<cmd>Lspsaga hover_doc<CR>";
    }
    {
      key = "<leader>lr";
      options.silent = true;
      options.desc = "Lsp Rename";
      action = "<cmd>Lspsaga rename<CR>";
    }
    {
      key = "<leader>lp";
      options.silent = true;
      options.desc = "Lsp Show Definition";
      action = "<cmd>Lspsaga peek_definition<CR>";
    }
    {
      key = "<leader>ld";
      options.silent = true;
      options.desc = "Lsp Goto Definition";
      action = "<cmd>Lspsaga goto_definition<CR>";
    }
    # LSP -- END
    # Telescope -- Start
    {
      key = "<leader>ff";
      options.desc = "Find Files";
      action = "<cmd>lua require('telescope.builtin').find_files({hidden = true})<CR>";
    }
    {
      key = "<leader>fg";
      options.desc = "Grep Files";
      action = "<cmd>lua require('telescope.builtin').live_grep({hidden = true})<CR>";
    }
    {
      key = "<leader>fb";
      options.desc = "Find Buffer";
      action = "<cmd>lua require('telescope.builtin').buffers()<CR>";
    }
    {
      key = "<leader>fh";
      options.desc = "Find Help";
      action = "<cmd>lua require('telescope.builtin').help_tags()<CR>";
    }
    {
      key = "<leader>fd";
      options.desc = "Find Diagnostics";
      action = "<cmd>lua require('telescope.builtin').diagnostics()<CR>";
    }
    {
      key = "<leader>ft";
      options.desc = "Find Treesitter";
      action = "<cmd>lua require('telescope.builtin').treesitter()<CR>";
    }
    # Telescope -- End
    # Noice -- Start
    # "<leader>c" = {
    #   options.desc = "Clear Messages";
    #   action = "<cmd>lua require('noice').cmd('dismiss')<CR>";
    # };
    # "<leader>fm" = {
    #   options.desc = "Find Messages";
    #   action = "<cmd>lua require('noice').cmd('telescope')<CR>";
    # };
    # Noice -- End
    {
      key = "jk";
      mode = "i";
      options.desc = "Esc";
      action = "<Esc>";
    }
    ];
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
      none-ls = {
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
        indent = {
          char = "";
        };
        scope = {
          enabled = false;
        };
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
