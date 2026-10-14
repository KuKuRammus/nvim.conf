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

        -- Shell
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
    },

    format_on_save = {
        timeout_ms = 5000,
        lsp_format = "fallback",
    },

    formatters = {
        -- C/C++ use default config from nvim
        ["clang-format"] = {
            prepend_args = function(_, ctx)
                local project = vim.fs.find({ ".clang-format", "_clang-format" }, {
                    path = ctx.dirname,
                    upward = true,
                })[1]

                if project then
                    return {}
                end

                return {
                    "--style=file:" .. vim.fn.stdpath("config") .. "/data/configs/.clang-format",
                }
            end,
        },

        -- Shell: 2-space indent, indent case branches
        shfmt = {
            prepend_args = { "-i", "4", "-ci" },
        },
    },
})
