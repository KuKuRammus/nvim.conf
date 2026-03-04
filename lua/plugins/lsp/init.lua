-- LSP stuff
--

-- Global capabilities (blink.cmp completion support)
vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})

-- Server configs
require("plugins.lsp.gopls")
require("plugins.lsp.clangd")
require("plugins.lsp.lua_ls")

-- Enable all
vim.lsp.enable({ "gopls", "clangd", "lua_ls" })

return {}
