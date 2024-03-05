vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.g.mapleader = " "
vim.cmd("set relativenumber")
vim.cmd("set nu rnu")

local autocmd_group = vim.api.nvim_create_augroup("Custom auto-commands", { clear = true })

vim.keymap.set('n', '<leader><leader>', '<c-^>')
