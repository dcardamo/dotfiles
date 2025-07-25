return {
  -- Avante.nvim - Claude integration that works with browser
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        -- Make sure to set up dressing.nvim
        "stevearc/dressing.nvim",
        opts = {
          input = {
            default_prompt = "➤ ",
            win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" },
          },
          select = {
            backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
            trim_prompt = true,
            get_config = function(opts)
              if opts.kind == "codeaction" then
                return {
                  backend = "telescope",
                  telescope = require("telescope.themes").get_cursor(),
                }
              end
            end,
          },
        },
      },
      {
        -- Optional: Provides nice diff support
        "echasnovski/mini.diff",
        version = false,
        config = function()
          require("mini.diff").setup()
        end,
      },
    },
    opts = {
      provider = "claude", -- or "openai", "azure", "gemini", "cohere", "copilot"
      auto_suggestions_provider = "claude",
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-20250514", -- Default to Sonnet 4
          -- Option 1: Use environment variable
          api_key_name = "ANTHROPIC_API_KEY",
          -- Option 2: Use a secure file
          -- api_key_name = "cmd:cat ~/.config/claude/api_key",
          extra_request_body = {
            max_tokens = 8192,
            temperature = 0,
          },
          -- Claude 4 models:
          -- "claude-opus-4-20250514" - Opus 4 (best for complex tasks, $15/$75 per M tokens)
          -- "claude-sonnet-4-20250514" - Sonnet 4 (great balance, $3/$15 per M tokens)
        },
      },
      behaviour = {
        auto_suggestions = false, -- Disable auto suggestions to avoid API key requirement
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
      },
      mappings = {
        diff = {
          ours = "co",
          theirs = "ct",
          all_theirs = "ca",
          both = "cb",
          cursor = "cc",
          next = "]x",
          prev = "[x",
        },
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
      },
      hints = { enabled = true },
      windows = {
        position = "right",
        wrap = true,
        width = 30,
        sidebar_header = {
          align = "center",
          rounded = true,
        },
      },
    },
    config = function(_, opts)
      require("avante").setup(opts)
      
      -- Helper function to switch models
      _G.switch_claude_model = function(model)
        local avante = require("avante")
        local config = require("avante.config")
        config.providers.claude.model = model
        vim.notify("Switched to " .. model, vim.log.levels.INFO)
      end
    end,
    keys = {
      { "<leader>aa", function() require("avante.api").ask() end, desc = "Avante: Ask", mode = { "n", "v" } },
      { "<leader>ar", function() require("avante.api").refresh() end, desc = "Avante: Refresh" },
      { "<leader>ae", function() require("avante.api").edit() end, desc = "Avante: Edit", mode = "v" },
      { "<leader>at", function() require("avante.api").toggle() end, desc = "Avante: Toggle" },
      { "<leader>af", function() require("avante.api").focus() end, desc = "Avante: Focus" },
      { "<leader>ac", function() require("avante").clear() end, desc = "Avante: Clear" },
      -- Model switching keybindings
      { "<leader>ams", function() _G.switch_claude_model("claude-sonnet-4-20250514") end, desc = "Use Sonnet 4" },
      { "<leader>amo", function() _G.switch_claude_model("claude-opus-4-20250514") end, desc = "Use Opus 4" },
    },
  },

  -- Session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir = vim.fn.stdpath("state") .. "/sessions/",
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
    },
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },

  -- Project management
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    opts = {
      manual_mode = false,
      detection_methods = { "pattern", "lsp" },
      patterns = {
        ".git",
        "_darcs",
        ".hg",
        ".bzr",
        ".svn",
        "Makefile",
        "package.json",
        "cargo.toml",
        "pyproject.toml",
        "flake.nix",
      },
      exclude_dirs = { "~/.cargo/*", "~/.npm/*" },
      show_hidden = true,
      silent_chdir = true,
      scope_chdir = "global",
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
      require("telescope").load_extension("projects")
    end,
    keys = {
      { "<leader>fp", "<cmd>Telescope projects<cr>", desc = "Projects" },
    },
  },
}