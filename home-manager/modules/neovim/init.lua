-- Set leader keys before loading lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
require("config.lazy")

-- Load core configurations
require("config.options")
require("config.keymaps")