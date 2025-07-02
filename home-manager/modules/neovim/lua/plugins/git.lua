return {
  -- Git signs in gutter
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- Navigation
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")

        -- Actions
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  -- Diffview
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    opts = {},
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "DiffView Close" },
    },
  },

  -- Neogit
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Commit" },
    },
    opts = {
      disable_hint = false,
      disable_context_highlighting = false,
      disable_signs = false,
      integrations = {
        diffview = true,
      },
      -- Custom key mappings
      mappings = {
        status = {
          ["?"] = "Help",
          ["q"] = "Close",
          ["<enter>"] = "Toggle",
          ["<tab>"] = "Toggle",
          ["s"] = "Stage",
          ["S"] = "StageAll",
          ["u"] = "Unstage",
          ["U"] = "UnstageAll",
          ["$"] = "CommandHistory",
          ["#"] = "Console",
          ["<c-r>"] = "RefreshBuffer",
          ["d"] = "DiffAtFile",
          ["i"] = "GoToFile",
          ["<c-v>"] = "VSplitOpen",
          ["<c-x>"] = "SplitOpen",
          ["<c-t>"] = "TabOpen",
          ["{"] = "GoToPreviousHunkHeader",
          ["}"] = "GoToNextHunkHeader",
        },
      },
    },
  },

  -- Git blame
  {
    "f-person/git-blame.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      enabled = false,
      message_template = " <author> • <date> • <summary>",
      date_format = "%r",
      virtual_text_column = 1,
    },
    keys = {
      { "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "Toggle Git Blame" },
    },
  },

  -- Git conflict
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("git-conflict").setup({
        default_mappings = false,
        default_commands = true,
        disable_diagnostics = false,
        highlights = {
          incoming = "DiffAdd",
          current = "DiffText",
        },
      })

      -- Custom mappings
      vim.keymap.set("n", "<leader>gco", "<Plug>(git-conflict-ours)", { desc = "Choose ours" })
      vim.keymap.set("n", "<leader>gct", "<Plug>(git-conflict-theirs)", { desc = "Choose theirs" })
      vim.keymap.set("n", "<leader>gcb", "<Plug>(git-conflict-both)", { desc = "Choose both" })
      vim.keymap.set("n", "<leader>gc0", "<Plug>(git-conflict-none)", { desc = "Choose none" })
      vim.keymap.set("n", "]x", "<Plug>(git-conflict-prev-conflict)", { desc = "Previous conflict" })
      vim.keymap.set("n", "[x", "<Plug>(git-conflict-next-conflict)", { desc = "Next conflict" })
    end,
  },
}