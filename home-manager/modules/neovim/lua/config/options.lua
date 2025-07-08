-- Basic options
vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = false -- Use absolute line numbers
vim.opt.mouse = "a"           -- Enable mouse
vim.opt.showmode = false      -- Don't show mode (lualine handles this)
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.breakindent = true    -- Enable break indent
vim.opt.undofile = true       -- Save undo history
vim.opt.ignorecase = true     -- Case insensitive searching
vim.opt.smartcase = true      -- Unless /C or capital in search
vim.opt.signcolumn = "yes"    -- Always show sign column
vim.opt.updatetime = 250      -- Decrease update time
vim.opt.timeoutlen = 300      -- Time to wait for mapped sequence
vim.opt.completeopt = "menuone,noselect" -- Better completion experience
vim.opt.termguicolors = true  -- True color support
vim.opt.cursorline = true     -- Highlight current line
vim.opt.scrolloff = 8         -- Lines of context
vim.opt.sidescrolloff = 8     -- Columns of context
vim.opt.wrap = false          -- Disable line wrap
vim.opt.splitright = true     -- Vertical splits to the right
vim.opt.splitbelow = true     -- Horizontal splits below

-- Tabs and indentation
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.shiftwidth = 2        -- Size of an indent
vim.opt.tabstop = 2           -- Number of spaces tabs count for
vim.opt.softtabstop = 2       -- Number of spaces in insert mode
vim.opt.smartindent = true    -- Smart indenting

-- Search
vim.opt.hlsearch = true       -- Highlight search results
vim.opt.incsearch = true      -- Incremental search

-- File handling
vim.opt.backup = false        -- Don't create backup files
vim.opt.writebackup = false   -- Don't create backup files
vim.opt.swapfile = false      -- Don't create swap files

-- UI
vim.opt.pumheight = 10        -- Popup menu height
vim.opt.conceallevel = 0      -- Show concealed characters
vim.opt.fillchars = {
  eob = " ",                  -- Hide ~ at end of buffer
  fold = " ",
  foldsep = " ",
}

-- Folding (with treesitter)
vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- Session options
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Grep
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep --smart-case --hidden"
  vim.opt.grepformat = "%f:%l:%c:%m"
end

-- Filetype-specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true  -- Wrap at word boundaries
  end,
})