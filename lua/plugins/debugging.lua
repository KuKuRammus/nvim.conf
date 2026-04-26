-- Debugging
--

local map = vim.keymap.set

-- nvim-dap - DAP client
-- https://github.com/mfussenegger/nvim-dap
vim.pack.add({ "https://github.com/mfussenegger/nvim-dap" })

local dap = require("dap")

-- Sign appearance
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "Error" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◉", texthl = "Error" })
vim.fn.sign_define("DapLogPoint", { text = "L", texthl = "" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "" })

-- [<leader>db] Toggle breakpoint
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })

-- [<leader>dD] Breakpoint with condition
map("n", "<leader>dB", function()
    dap.set_breakpoint(vim.fn.input("Condition: "))
end, { desc = "Conditional breakpoint" })

-- [<leader>dl] Log point
map("n", "<leader>dl", function()
    dap.set_breakpoint(nil, nil, vim.fn.input("Log: "))
end, { desc = "Log point" })

-- [<leader>dc] Start/Continue debugging
map("n", "<leader>dc", dap.continue, { desc = "Continue" })

-- [<leader>do] Step over
map("n", "<leader>do", dap.step_over, { desc = "Step over" })

-- [<leader>di] Step into
map("n", "<leader>di", dap.step_into, { desc = "Step into" })

-- [<leader>dt] Step out
map("n", "<leader>dt", dap.step_out, { desc = "Step out" })

-- [<leader>dx] Terminate debugging
map("n", "<leader>dx", dap.terminate, { desc = "Terminate" })

-- [<leader>dr] Open REPL
map("n", "<leader>dr", dap.repl.open, { desc = "REPL" })

-- Adapters: Go (delve)
dap.adapters.delve = {
    type = "server",
    port = "${port}",
    executable = { command = "dlv", args = { "dap", "-l", "127.0.0.1:${port}" } },
}
dap.configurations.go = {
    {
        type = "delve",
        name = "Debug",
        request = "launch",
        program = "${file}",
    },
    {
        type = "delve",
        name = "Debug (package)",
        request = "launch",
        program = "${fileDirname}",
    },
    {
        type = "delve",
        name = "Debug test",
        request = "launch",
        mode = "test",
        program = "${file}",
    },
    {
        type = "delve",
        name = "Debug test (package)",
        request = "launch",
        mode = "test",
        program = "${fileDirname}",
    },
}

-- Adapters: C/C++ (gdb)
dap.adapters.gdb = {
    type = "executable",
    command = "gdb",
    args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
}
dap.configurations.c = {
    {
        type = "gdb",
        name = "Debug",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopAtBeginningOfMainSubprogram = false,
    },
    {
        type = "gdb",
        name = "Attach to process",
        request = "attach",
        pid = function()
            return vim.fn.input("PID: ")
        end,
    },
}
dap.configurations.cpp = dap.configurations.c

-- nvim-dap-ui - UI for the DAP client
-- https://github.com/rcarriga/nvim-dap-ui
vim.pack.add({
    "https://github.com/rcarriga/nvim-dap-ui",

    -- dependency
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/nvim-neotest/nvim-nio",
})

local ui = require("dapui")
ui.setup()

-- [<leader>du]: Toggle DAP UI
map("n", "<leader>du", ui.toggle, { desc = "Toggle DAP UI" })

-- Auto open/close UI
dap.listeners.after.event_initialized["dapui_config"] = function()
    ui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    ui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    ui.close()
end

-- nvim-dap-virtual-text - Adds virtual text with variable values during debug
-- https://github.com/theHamsta/nvim-dap-virtual-text
vim.pack.add({ "https://github.com/theHamsta/nvim-dap-virtual-text" })

require("nvim-dap-virtual-text").setup()
