-- Code formatting
--

-- conform.nvim - Formatter
-- https://github.com/stevearc/conform.nvim
vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

require("conform").setup({
    formatters_by_ft = {
        go   = { "goimports", "goimports-reviser" },
        c    = { "clang-format" },
        cpp  = { "clang-format" },
        lua  = { "stylua" },
    },

    format_on_save = {
        timeout_ms = 5000,
        lsp_format = "fallback",
    },
})