return {
    { 'VonHeikemen/lsp-zero.nvim', branch = 'v3.x' },
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            setup = {
                rust_analyzer = function()
                    return true
                end
            },
            ensure_installed = { "lua_ls", "rust_analyzer", "bzl" }
        }
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            local lspconfig = require("lspconfig")

            lspconfig.tsserver.setup({
                capabilities = capabilities
            })
            lspconfig.html.setup({
                capabilities = capabilities
            })
            lspconfig.lua_ls.setup({
                capabilities = capabilities
            })
            lspconfig.bzl.setup({
                capabilities = capabilities
            })
            lspconfig.sourcekit.setup({
                capabilities = capabilities,
                root_dir = lspconfig.util.root_pattern("*")
            })
            lspconfig.yamlls.setup({
                capabilities = capabilities
            })


            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id).server_capabilities
                    if client.documentFormattingProvider then
                        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                            pattern = { "*" },
                            desc = "Auto format lua files",
                            callback = function()
                                vim.lsp.buf.format()
                            end
                        })
                    end
                    if client.hoverProvider then
                        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = args.buf })
                    end
                    vim.lsp.inlay_hint.enable(args.buf, true)
                    if client.definitionProvider then
                        vim.keymap.set("n", "gd", vim.lsp.buf.declaration, { buffer = args.buf })
                    end
                    if client.referencesProvider then
                        vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = args.buf })
                    end
                    if client.codeActionProvider then
                        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = args.buf })
                    end
                end,
            })
        end,
    },
}
