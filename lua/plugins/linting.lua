-- Linting
--

return {
	-- nvim-lint - Linter
	-- https://github.com/mfussenegger/nvim-lint
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufWritePost", "InsertLeave" },
		config = function()
			local lint = require("lint")

			-- Linters
			lint.linters_by_ft = {
				go = { "golangcilint" },
				lua = { "luacheck" },
			}

			-- Trigger
			vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
				group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
}
