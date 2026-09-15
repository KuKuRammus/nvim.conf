-- Linting
--

-- nvim-lint - Linter
-- https://github.com/mfussenegger/nvim-lint
vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })

local lint = require("lint")

lint.linters_by_ft = {
    -- Go
    go = { "golangcilint" },

    -- Lua
    lua = { "luacheck" },
}

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
    callback = function()
        lint.try_lint()
    end,
})
