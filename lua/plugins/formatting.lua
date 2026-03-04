-- Code formatting
--

return {
	-- conform.nvim - Formatter
	-- https://github.com/stevearc/conform.nvim
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		config = function()
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = {
					go = { "goimports", "goimports-reviser" },
					c = { "clang-format" },
					cpp = { "clang-format" },
					lua = { "stylua" },
				},

				format_on_save = {
					timeout_ms = 5000,
					lsp_format = "fallback",
				},
			})
		end,
	},
}
