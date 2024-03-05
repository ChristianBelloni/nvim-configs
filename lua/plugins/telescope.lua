return {
    {
        "nvim-telescope/telescope-ui-select.nvim",
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })
            local map = vim.keymap.set
            local builtin = require("telescope.builtin")
            map("n", "<C-p>", builtin.find_files, {})
            map("n", "<leader>fg", builtin.live_grep, {})
            map('n', '<leader>b', builtin.buffers)

            require("telescope").load_extension("ui-select")
        end,
    },
}
