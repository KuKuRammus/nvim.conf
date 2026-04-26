-- Theme / Colors
--

-- kanagawa.nvim
-- https://github.com/rebelot/kanagawa.nvim
vim.pack.add({ "https://github.com/rebelot/kanagawa.nvim" })

require("kanagawa").setup({ compile = true })

vim.cmd.colorscheme("kanagawa-wave")
