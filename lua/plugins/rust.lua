return {
    {
        'mrcjkb/rustaceanvim',
        version = '^5', -- Recommended
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
                            cargo = {
                                buildScripts = {
                                    enable = true,
                                },
                                allTargets = true,
                                allFeatures = true
                            },
                            procMacro = {
                                enable = true
                            },
                            add_return_type = {
                                enable = true
                            },
                            diagnostics = {
                                disabled = {'inactive-code'},
                            },
                            inlayHints = {
                                enable = true,
                                showParameterNames = true,
                                parameterHintsPrefix = "<- ",
                                otherHintsPrefix = "=> ",
                            },
                        },
                    },
                },
            }
        end
    },
    {
        'saecki/crates.nvim',
        tag = 'stable',
    }
}
