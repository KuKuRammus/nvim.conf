-- linting
--

return {
    -- nvim-lint - Linter
    -- https://github.com/mfussenegger/nvim-lint
    {
        "mfussenegger/nvim-lint",
        config = function()
            local lint = require("lint")

            -- eslint
            vim.env.ESLINT_D_PPID = vim.fn.getpid()
            lint.linters.eslint_d = {
                cmd = "npx",
                args = { "eslint_d", "--stdin", "--stdin-filename", "%filepath" },
                stdin = true,
            }

            -- Linters
            lint.linters_by_ft = {
                -- https://golangci-lint.run/
                go = { "golangcilint" },

                -- https://www.npmjs.com/package/eslint_d
                javascript = {'eslint_d'},
                typescript = {'eslint_d'},
                javascriptreact = {'eslint_d'},
                typescriptreact = {'eslint_d'},
            }

            -- Trigger
            vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
                group = vim.api.nvim_create_augroup("linting", { clear = true }),
                callback = function(e)
                    lint.try_lint()
                end
            })
        end,
    }
}
