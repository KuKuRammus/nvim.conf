-- code formatting
--

return {
    -- conform.nvim - Formatter
    -- https://github.com/stevearc/conform.nvim
    {
        "stevearc/conform.nvim",
        config = function()
            local conform = require("conform")

            conform.setup({
                formatters_by_ft = {
                    -- https://github.com/mvdan/gofumpt
                    -- https://pkg.go.dev/golang.org/x/tools/cmd/goimports (auto imports)
                    -- https://github.com/incu6us/goimports-reviser
                    go = { "gofumpt", "goimports", "goimports-reviser" },

                    -- eslint_d
                    javascript = { "eslint_d" },
                    typescript = { "eslint_d" },
                    javascriptreact = { "eslint_d" },
                    typescriptreact = { "eslint_d" },
                },

                formatters = {
                    -- gofumpt
                    -- https://github.com/stevearc/conform.nvim/issues/387
                    gofumpt = {
                        command = "gofumpt",
                        args = { "$FILENAME" },
                        stdin = false,
                    },
                },

                format_on_save = {
                    -- These options will be passed to conform.format()
                    timeout_ms = 10000,
                    lsp_format = "fallback",
                }
            })
        end,
    }
}
