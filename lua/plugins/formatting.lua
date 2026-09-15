-- Code formatting
--

-- conform.nvim - Formatter
-- https://github.com/stevearc/conform.nvim
vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

local conform = require("conform")

conform.setup({
    formatters_by_ft = {
        -- Go
        go = { "goimports", "goimports-reviser" },

        -- C/C++
        c = { "clang-format" },
        cpp = { "clang-format" },

        -- Lua
        lua = { "stylua" },
    },

    format_on_save = {
        timeout_ms = 5000,
        lsp_format = "fallback",
    },
})
