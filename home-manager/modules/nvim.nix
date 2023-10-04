{
  config,
  pkgs,
  ...
}: let
  inherit (pkgs) stdenv;
  inherit (stdenv) isLinux;
in {
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
        "<leader>c" = {
          desc = "Clear Messages";
          action = "<cmd>lua require('noice').cmd('dismiss')<CR>";
        };
        "<leader>fm" = {
          desc = "Find Messages";
          action = "<cmd>lua require('noice').cmd('telescope')<CR>";
        };
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
      gitsigns = {
        enable = true;
        currentLineBlame = false;
      };
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
          pylsp.enable = true;
        };
      };
      lspkind = {
        enable = true;
      };
      rust-tools = {
        enable = true;
        server.check.command = "clippy";
      };
      null-ls.enable = true;
      lsp-lines.enable = true;
      lspsaga = {
        enable = true;
        # lightbulb = {
        #   enable = true;
        #   virtualText = false;
        # };
        # symbolInWinbar.enable = false;
        # ui.border = "rounded";
      };
      luasnip.enable = true;
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
        useTreesitter = true;
        showCurrentContext = false;
        showEndOfLine = true;
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
