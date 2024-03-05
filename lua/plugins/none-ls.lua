return {
    "nvimtools/none-ls.nvim",
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.buildifier,
                null_ls.builtins.formatting.swiftformat,
                null_ls.builtins.diagnostics.swiftlint,
            },
        })

        -- vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
    end,
}
