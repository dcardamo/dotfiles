-- Setup lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Ensure lazy.nvim is installed
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup({
  spec = {
    -- Import plugin specifications
    { import = "plugins.ui" },
    { import = "plugins.editor" },
    { import = "plugins.lsp" },
    { import = "plugins.git" },
    { import = "plugins.telescope" },
    { import = "plugins.ai" },
  },
  defaults = {
    lazy = false,
    version = false, -- always use the latest git commit
  },
  install = {
    colorscheme = { "tokyonight-moon" },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  rocks = {
    enabled = false, -- Disable luarocks support
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})