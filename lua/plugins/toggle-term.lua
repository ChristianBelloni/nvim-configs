return {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
        require("toggleterm").setup({})

        vim.keymap.set("n", "t", ":ToggleTerm direction=horizontal size=24<CR>")
        vim.keymap.set('t', '<esc>', '<C-\\><C-n>:ToggleTerm direction=horizontal<CR>',
            { noremap = true, silent = true })
    end
}
