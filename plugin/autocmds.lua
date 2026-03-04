-- Autocommands
--

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 250 })
	end,
})

-- LSP keymaps — attached when any LSP server connects to a buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-keymaps", { clear = true }),
	callback = function(event)
		local buf = event.buf
		local opts = { noremap = true, silent = true, buffer = buf }

		-- [gd] Go to definition
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

		-- [gr] Show references
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

		-- TODO: Might use fzf for references
		-- vim.keymap.set("n", "gr", function()
		--     require("fzf-lua").lsp_references()
		-- end, opts)

		-- [gi] Go to implementation
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

		-- [K] Hover documentation
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

		-- [Ctrl-k] Signature help
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

		-- [gn] Rename symbol
		vim.keymap.set("n", "gn", vim.lsp.buf.rename, opts)

		-- [ga] Code actions (quick fixes, refactors, etc)
		vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)

		-- [gD] Go to declaration (different from definition for C headers)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

		-- []x] Diagnostic navigation - next
		vim.keymap.set("n", "]x", function()
			vim.diagnostic.goto_next({ float = false })
		end, opts)

		-- [[x] Diagnostic navigation - prev
		vim.keymap.set("n", "[x", function()
			vim.diagnostic.goto_prev({ float = false })
		end, opts)
	end,
})
