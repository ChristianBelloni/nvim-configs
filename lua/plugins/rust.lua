return {
    {
        'mrcjkb/rustaceanvim',
        version = '^4', -- Recommended
        ft = { 'rust' },
        config = function()
            vim.g.rustaceanvim = {
                -- Plugin configuration
                tools = {
                },
                -- LSP configuration
                server = {
                    on_attach = function(client, bufnr)
                        -- you can also put keymaps in here
                    end,
                    default_settings = {
                        -- rust-analyzer language server configuration
                        ['rust-analyzer'] = {
                        },
                    },
                },
                -- DAP configuration
                dap = {
autoload_configurations = true
                },
            }
        end
    },
    {
        'saecki/crates.nvim',
        tag = 'stable',
        config = function()
            require("crates").setup {
                null_ls = {
                    enabled = true,
                    name = "crates.nvim",
                },
            }
        end,
    }
}
