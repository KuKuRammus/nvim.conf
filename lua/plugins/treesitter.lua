-- Treesitter
--

-- nvim-treesitter - Treesitter
-- https://github.com/nvim-treesitter/nvim-treesitter
vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

local parsers = {
    "bash",
    "c",
    "cmake",
    "cpp",
    "css",
    "dockerfile",
    "go",
    "gomod",
    "gosum",
    "gowork",
    "html",
    "javascript",
    "json",
    "lua",
    "luadoc",
    "make",
    "markdown",
    "markdown_inline",
    "php",
    "python",
    "query",
    "regex",
    "scss",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
};

-- Install/update parsers on first launch and whenever the plugin updates
require("nvim-treesitter").install(parsers)

-- Re-run install after vim.pack updates the plugin (per the official guidance)
vim.api.nvim_create_autocmd("PackChanged", {
    group = vim.api.nvim_create_augroup("treesitter-update", { clear = true }),
    callback = function(ev)
        if ev.data.spec.name == "nvim-treesitter" and ev.data.kind == "update" then
            require("nvim-treesitter").install(parsers):wait(60000)
        end
    end,
})