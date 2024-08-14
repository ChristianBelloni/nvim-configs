return {
    {
        'mrcjkb/rustaceanvim',
        version = '^5', -- Recommended
        lazy = false, -- This plugin is already lazy
        config = function()
        vim.g.rustaceanvim = {
        -- Plugin configuration
        tools = {
          autoSetHints = true,
          inlay_hints = {
            show_parameter_hints = true,
            parameter_hints_prefix = "in: ", -- "<- "
            other_hints_prefix = "out: "     -- "=> "
          }
        },
        -- LSP configuration
        --
        -- REFERENCE:
        -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
        -- https://rust-analyzer.github.io/manual.html#configuration
        -- https://rust-analyzer.github.io/manual.html#features
        --
        -- NOTE: The configuration format is `rust-analyzer.<section>.<property>`.
        --       <section> should be an object.
        --       <property> should be a primitive.
        server = {
          on_attach = function(client, bufnr)
            require("lsp-inlayhints").setup({
              inlay_hints = { type_hints = { prefix = "=> " } }
            })
            require("lsp-inlayhints").on_attach(client, bufnr)
            require("illuminate").on_attach(client)

            local bufopts = {
              noremap = true,
              silent = true,
              buffer = bufnr
            }
            vim.keymap.set('n', '<leader><leader>rr',
              "<Cmd>RustLsp runnables<CR>", bufopts)
            vim.keymap.set('n', 'K',
              "<Cmd>RustLsp hover actions<CR>", bufopts)
          end,
          settings = {
            -- rust-analyzer language server configuration
            ['rust-analyzer'] = {
              assist = {
                importEnforceGranularity = true,
                importPrefix = "create"
              },
              cargo = { allFeatures = true },
              checkOnSave = {
                -- default: `cargo check`
                command = "+stable clippy",
                allFeatures = true
              },
              inlayHints = {
                lifetimeElisionHints = {
                  enable = true,
                  useParameterNames = true
                }
              }
            }
          }
        }
      }
    end
  },
  {
    -- LSP INLAY HINTS
    "lvimuser/lsp-inlayhints.nvim",
    dependencies = "neovim/nvim-lspconfig"
  },
  {
    -- WORD USAGE HIGHLIGHTER
    "RRethy/vim-illuminate"
  },
    {
        'saecki/crates.nvim',
        
    },
    {
	'alx741/vim-rustfmt',
	branch = 'master'
    },
      {
    -- LSP VIRTUAL TEXT
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()

      -- disable virtual_text since it's redundant due to lsp_lines.
      vim.diagnostic.config({ virtual_text = false })

      -- TODO: Consider https://github.com/folke/lazy.nvim/discussions/1652
    end
  },
}
