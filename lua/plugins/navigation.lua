-- Navigation
--

return {
	-- fzf-lua - fuzzy finder for files, grep, LSP, and more
	-- https://github.com/ibhagwan/fzf-lua
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local fzf = require("fzf-lua")
			fzf.setup({
				-- Use "fzf-native" for fzf-like interface
				-- Other options: "telescope", "max-perf"
				"fzf-native",

				winopts = {
					height = 0.85,
					width = 0.80,
					preview = {
						layout = "horizontal",
						horizontal = "right:60%",
					},
				},
			})

			-- [<leader>ff]: Find files (git files if in repo, all files otherwise)
			vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })

			-- [<leader>fg]: Live grep across project
			vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Live grep" })

			-- [<leader>fb]: Open buffers
			vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })

			-- [<leader>fh]: Help tags
			vim.keymap.set("n", "<leader>fh", fzf.helptags, { desc = "Help tags" })

			-- [<leader>fr]: LSP references
			vim.keymap.set("n", "<leader>fr", fzf.lsp_references, { desc = "LSP references" })

			-- [<leader>fs]: LSP document symbols
			vim.keymap.set("n", "<leader>fs", fzf.lsp_document_symbols, { desc = "LSP document symbols" })

			-- [<leader>fd]: Diagnostics
			vim.keymap.set("n", "<leader>fd", fzf.diagnostics_document, { desc = "Document diagnostics" })

			-- [<leader>fq]: Quickfix list
			vim.keymap.set("n", "<leader>fq", fzf.quickfix, { desc = "Quickfix" })
		end,
	},

	-- oil.nvim - Filesystem navigation and management in buffer-like style
	-- https://github.com/stevearc/oil.nvim
	{
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup({
				columns = {
					"icon",
					"permissions",
					"size",
				},

				-- Send deleted files to the trash instead of permanently deleting them
				delete_to_trash = true,

				view_options = {
					show_hidden = true,
				},
			})

			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		end,
	},
}
