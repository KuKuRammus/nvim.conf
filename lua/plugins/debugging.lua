-- Debugging
--

return {
    -- nvim-dap - DAP client
    -- https://github.com/mfussenegger/nvim-dap
    {
        "mfussenegger/nvim-dap",
        config = function ()
            local dap = require("dap")
            local ui = require("dapui")
            local opts = { noremap = true, silent = true }

            -- Breakpoint marker looks
            vim.fn.sign_define('DapBreakpoint', {text='●', texthl='Error', linehl='', numhl='Error'})
            vim.fn.sign_define('DapBreakpointCondition', {text='◉', texthl='Error', linehl='', numhl='Error'})
            vim.fn.sign_define('DapLogPoint', {text='󱂅', texthl='', linehl='', numhl=''})
            vim.fn.sign_define('DapStopped', {text='', texthl='', linehl='', numhl=''})

            -- TODO: Add description to keymaps

            -- [<leader><leader>bb]: Toggle breakpoint
            vim.keymap.set("n", "<leader><leader>bb", dap.toggle_breakpoint, opts)

            -- [<leader><leader>bv]: Set conditional break
            vim.keymap.set("n", "<leader><leader>bv", function ()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end, opts)

            -- [<leader><leader>bl]: Set log point
            vim.keymap.set("n", "<leader><leader>bl", function ()
                dap.set_breakpoint(nil, nil, vim.fn.input("LOG: "))
            end, opts)

            -- [<leader><leader>bc]: Start/Continue
            vim.keymap.set("n", "<leader><leader>bc", dap.continue, opts)

            -- [<leader><leader>bx]: Stop
            vim.keymap.set("n", "<leader><leader>bx", dap.close, opts)

            -- [<leader><leader>bo]: Step over
            vim.keymap.set("n", "<leader><leader>bo", dap.step_over, opts)

            -- [<leader><leader>bi]: Step into
            vim.keymap.set("n", "<leader><leader>bi", dap.step_into, opts)

            -- [<leader><leader>bt]: Step out
            vim.keymap.set("n", "<leader><leader>bt", dap.step_out, opts)

            -- [<leader><leader>br]: Launch REPL
            vim.keymap.set("n", "<leader><leader>br", dap.repl.open, opts)

            -- [<leader><leader>bu]: Toggle UI
            vim.keymap.set("n", "<leader><leader>bu", ui.toggle, opts)
        end,
    },

    -- nvim-dap-ui - UI for the DAP client
    -- https://github.com/rcarriga/nvim-dap-ui
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = true,

        -- Check `:h dap.repl.open()` for available commands inside REPL
    },

    -- nvim-dap-go - Configuration for Go (delve) debugger
    -- https://github.com/leoluz/nvim-dap-go
    -- TODO: Not sure if I even need this. Might be better idea to setup config myself
    {
        "leoluz/nvim-dap-go",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        config = true,
    },

    -- nvim-dap-virtual-text - Adds virtual text with variable values during debug
    -- https://github.com/theHamsta/nvim-dap-virtual-text
    {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        config = true,
    },
}
