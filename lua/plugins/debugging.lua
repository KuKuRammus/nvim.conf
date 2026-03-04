-- Debugging
--

return {
	-- nvim-dap - DAP client
	-- https://github.com/mfussenegger/nvim-dap
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")

			-- Breakpoint marker appearance
			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "Error", linehl = "", numhl = "Error" })
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "◉", texthl = "Error", linehl = "", numhl = "Error" }
			)
			vim.fn.sign_define("DapLogPoint", { text = "󱂅", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapStopped", { text = "", texthl = "", linehl = "", numhl = "" })

			-- [<leader>db] Toggle breakpoint
			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })

			-- [<leader>dD] Breakpoint with condition
			vim.keymap.set("n", "<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Condition: "))
			end, { desc = "Conditional breakpoint" })

			-- [<leader>dl] Log point
			vim.keymap.set("n", "<leader>dl", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Log: "))
			end, { desc = "Log point" })

			-- [<leader>dc] Start/Continue debugging
			vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Start/Continue" })

			-- [<leader>do] Step over
			vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })

			-- [<leader>di] Step into
			vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })

			-- [<leader>dt] Step out
			vim.keymap.set("n", "<leader>dt", dap.step_out, { desc = "Step out" })

			-- [<leader>dx] Terminate debugging
			vim.keymap.set("n", "<leader>dx", dap.terminate, { desc = "Terminate" })

			-- [<leader>dr] Open REPL
			vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })

			--
			-- Go (delve)
			dap.adapters.delve = {
				type = "server",
				port = "${port}",
				executable = {
					command = "dlv",
					args = { "dap", "-l", "127.0.0.1:${port}" },
				},
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

			--
			-- C/C++ (gdb)
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
		config = function()
			local dap = require("dap")
			local ui = require("dapui")

			ui.setup()

			-- Auto open/close UI when debugging starts/stops
			dap.listeners.after.event_initialized["dapui_config"] = function()
				ui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				ui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				ui.close()
			end

			-- [<leader>du]: Toggle DAP UI
			vim.keymap.set("n", "<leader>du", ui.toggle, { desc = "Toggle DAP UI" })
		end,
	},

	-- nvim-dap-virtual-text - Adds virtual text with variable values during debug
	-- https://github.com/theHamsta/nvim-dap-virtual-text
	{
		"theHamsta/nvim-dap-virtual-text",
		dependencies = { "mfussenegger/nvim-dap" },
		config = true,
	},
}

