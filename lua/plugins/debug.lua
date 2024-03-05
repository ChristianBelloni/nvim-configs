return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "leoluz/nvim-dap-go",
        "rcarriga/nvim-dap-ui",
    },
    config = function()
        require("dapui").setup()
        require("dap-go").setup()

        local dap, dapui = require("dap"), require("dapui")

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
            vim.cmd.Neotree('close')
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
            vim.cmd.Neotree('close')
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
            vim.cmd.Neotree('filesystem')
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
            vim.cmd.Neotree('filesystem')
        end

        vim.keymap.set("n", "<Leader>dt", ":DapToggleBreakpoint<CR>")
        vim.keymap.set("n", "<Leader>dc", ":DapContinue<CR>")
        vim.keymap.set("n", "<Leader>dx", ":DapTerminate<CR>")
        vim.keymap.set("n", "<Leader>do", ":DapStepOver<CR>")

        -- vim.keymap.set("n", "<Leader>du", ":lua require('dapui').open()<CR>")
        -- vim.keymap.set("n", "<Leader>ds", ":lua require('dapui').close()<CR>")

        local mason_registry = require('mason-registry')

        local codelldb = mason_registry.get_package("codelldb") -- note that this will error if you provide a non-existent package name
        codelldb:get_install_path()                             -- returns a string like "/home/user/.local/share/nvim/mason/packages/codelldb"

        -- local extension_path = codelldb:get_install_path() .. "/codelldb"

        -- dap.adapters.codelldb = {
        --     type = "executable",
        --     command = extension_path,
        --     name = "codelldb"
        -- }
        --  dap.configurations.rust = {
        --      {
        --          name = 'Launch',
        --          type = 'lldb',
        --          request = 'launch',
        --          program = function()
        --              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        --          end,
        --          cwd = '${workspaceFolder}',
        --          stopOnEntry = false,
        --          args = {},

        --          -- 💀
        --          -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
        --          --
        --          --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
        --          --
        --          -- Otherwise you might get the following error:
        --          --
        --          --    Error on launch: Failed to attach to the target process
        --          --
        --          -- But you should be aware of the implications:
        --          -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
        --          -- runInTerminal = false,
        --      },
        --  }
    end,
}
