-- Navigation
--

-- fzf-lua - fuzzy finder for files, grep, LSP, and more
-- https://github.com/ibhagwan/fzf-lua
vim.pack.add({
    "https://github.com/ibhagwan/fzf-lua",

    -- dependency
    "https://github.com/nvim-tree/nvim-web-devicons"
})

local fzf = require("fzf-lua")
fzf.setup({
    "fzf-native",
    winopts = {
        height = 0.85,
        width = 0.80,
        preview = { layout = "horizontal", horizontal = "right:60%" },
    },
})

-- [<leader>ff]: Find files (git files if in repo, all files otherwise)
vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })

-- [<leader>fg]: Live grep across project
vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Live grep" })

-- [<leader>fb]: Open buffers
vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })

-- [<leader>fh]: Help tags
vim.keymap.set("n", "<leader>fh", fzf.helptags, { desc = "Help tags" })

-- [<leader>fr]: LSP references
vim.keymap.set("n", "<leader>fr", fzf.lsp_references, { desc = "LSP references" })

-- [<leader>fs]: LSP document symbols
vim.keymap.set("n", "<leader>fs", fzf.lsp_document_symbols, { desc = "LSP symbols" })

-- [<leader>fd]: Diagnostics
vim.keymap.set("n", "<leader>fd", fzf.diagnostics_document, { desc = "Diagnostics" })

-- [<leader>fq]: Quickfix list
vim.keymap.set("n", "<leader>fq", fzf.quickfix, { desc = "Quickfix" })

-- oil.nvim - Filesystem navigation and management in buffer-like style
-- https://github.com/stevearc/oil.nvim
vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

require("oil").setup({
    columns = { "icon", "permissions", "size" },
    delete_to_trash = true,
    view_options = { show_hidden = true },
})

vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Parent directory" })