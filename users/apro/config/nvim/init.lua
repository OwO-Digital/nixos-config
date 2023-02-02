vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.termguicolors  = true
vim.opt.wrap           = false

vim.api.nvim_create_user_command("WQ", "wq", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("W",  "w",  {})
vim.api.nvim_create_user_command("Q",  "q",  {})

require 'plugins'

local _, everblush = pcall(require, 'everblush')

everblush.setup({ nvim_tree = { contrast = true } })
