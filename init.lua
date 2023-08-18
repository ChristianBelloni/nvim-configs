vim.g.mapleader = ' '


local Plug = vim.fn['plug#']
function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug('rcarriga/nvim-dap-ui')
Plug('iamcco/markdown-preview.nvim')
Plug('Ciel-MC/rust-tools.nvim')
Plug('junegunn/fzf', {['do'] = vim.fn['fzf#install']})
Plug('dag/vim-fish')
Plug('junegunn/fzf.vim')
Plug('airblade/vim-rooter')
Plug('nvim-tree/nvim-tree.lua')
Plug('nvim-tree/nvim-web-devicons')
Plug ('RRethy/nvim-base16')
Plug('neovim/nvim-lspconfig')
Plug('mfussenegger/nvim-dap')

Plug('nvim-lua/plenary.nvim')
Plug('saecki/crates.nvim')
Plug("rust-lang/rust.vim")


Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-nvim-lua')
Plug('hrsh7th/cmp-nvim-lsp-signature-help')
Plug('hrsh7th/cmp-vsnip')                             
Plug('hrsh7th/cmp-path')                            
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/vim-vsnip')
Plug('puremourning/vimspector')
Plug('voldikss/vim-floaterm')
Plug('akinsho/toggleterm.nvim', {tag = '*'})

vim.call('plug#end')

require("toggleterm").setup()
local rt = require("rust-tools")

local extension_path = vim.env.HOME
  .. "/.vscode/extensions/vadimcn.vscode-lldb-1.9.0/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"


rt.setup({
    executor = require("rust-tools.executors").toggleterm,
    server = {
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      vim.keymap.set("n", "<C-o>", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
    standalone = true,
  },
    dap = {
        adapter = require("rust-tools.dap").get_codelldb_adapter(
            codelldb_path,
            liblldb_path
        ),
  },
})
local dap = require("dap")
dap.defaults.fallback.terminal_win_cmd = "50vsplit new"
require('rust-tools').inlay_hints.enable()
require('rust-tools').inlay_hints.set()
require'rust-tools'.hover_actions.hover_actions()
require'rust-tools'.hover_range.hover_range()
require('rust-tools').runnables.runnables()
require("nvim-tree").setup({
    on_attach = "open",
    view = {
        side = "left",
        width = 30,
        relativenumber = true,
    },
    actions = {
        open_file = {
        }
    }
})
require('crates').setup()

vim.lsp.buf.hover()

vim.cmd('colorscheme base16-gruvbox-dark-hard')
map("n", "<C-p>", ":GFiles<cr>")
map("n", "<C-o>", ":Buffers<cr>")
map("n", "<C-r>", ":Rg<cr>")

vim.cmd("let g:fzf_layout = { 'down':  '40%'}")

-- LSP Diagnostics Options Setup 
local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = ''})
sign({name = 'DiagnosticSignWarn', text = ''})
sign({name = 'DiagnosticSignHint', text = ''})
sign({name = 'DiagnosticSignInfo', text = ''})

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
vim.opt.shortmess = vim.opt.shortmess + { c = true}
vim.api.nvim_set_option('updatetime', 300) 

-- Fixed column for diagnostics to appear
-- Show autodiagnostic popup on cursor hover_range
-- Goto previous / next diagnostic warning / error 
-- Show inlay_hints more frequently 
vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

vim.cmd("let g:rustfmt_autosave = 1")
-- Completion Plugin Setup
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  -- Installed sources:
  sources = {
    { name = 'path' },                              -- file paths
    { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
    { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
    { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
    { name = 'buffer', keyword_length = 2 },        -- source current buffer
    { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
    { name = 'calc'},                               -- source for math calculation
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
          local menu_icon ={
              nvim_lsp = 'λ',
              vsnip = '⋗',
              buffer = 'Ω',
              path = '🖫',
          }
          item.menu = menu_icon[entry.source.name]
          return item
      end,
  },
})

-- Vimspector options
vim.cmd([[
let g:vimspector_sidebar_width = 85
let g:vimspector_bottombar_height = 15
let g:vimspector_terminal_maxwidth = 70
]])

-- Vimspector
vim.cmd([[
nmap <C-e> <cmd>call vimspector#Launch()<cr>
nmap <F5> <cmd>call vimspector#StepOver()<cr>
nmap <F8> <cmd>call vimspector#Reset()<cr>
nmap <F11> <cmd>call vimspector#StepOver()<cr>")
nmap <F10> <cmd>call vimspector#StepInto()<cr>")
]])
map('n', "Dw", ":call vimspector#AddWatch()<cr>")
map('n', "De", ":call vimspector#Evaluate()<cr>")

vim.g.floaterm_wintype="split"
vim.g.floaterm_height=0.2

-- FloaTerm configuration
map('n', "<leader>ft", ":FloatermNew --name=myfloat --height=0.8 --width=0.7 --autoclose=2 --wintype=split fish <CR> ")
map('n', "t", ":FloatermToggle myfloat<CR>")
map('t', "<Esc>", "<C-\\><C-n>:q<CR>")

local opts = { noremap=true, silent=true }
map('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
map('n', '<F12>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
vim.cmd("nnoremap <leader><leader> <c-^>")

vim.wo.relativenumber = true
require'nvim-tree.view'.View.winopts.relativenumber = true

vim.cmd("autocmd VimEnter,WinEnter * let &scrolloff = winheight(0) / 5 * 2")
vim.cmd(":set number relativenumber")
vim.cmd(":set nu rnu")

map('n', "Db", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)

require("dapui").setup({
  icons = { expanded = "▾", collapsed = "▸" },

  lspconfig = {
    cmd = { "lua-language-server" },
    on_attach = function(c, b)
    end,
    settings = {
      Lua = {
        hint = {
          enable = true,
        },
      },
    },
  },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has("nvim-0.7"),
  -- Layouts define sections of the screen to place windows.
  -- The position can be "left", "right", "top" or "bottom".
  -- The size specifies the height/width depending on position. It can be an Int
  -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
  -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
  -- Elements are the elements shown in the layout (in order).
  -- Layouts are opened in order so that earlier layouts take priority in window sizing.
  layouts = {
    {
      elements = {
        -- Elements can be strings or table with id and size keys.
        {
          id = "scopes",
          size = 0.25,
        },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
  },
})
