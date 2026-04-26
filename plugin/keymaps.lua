-- Global keymaps
--

local map = vim.keymap.set

-- [<leader>uu] Built-in undotree
map("n", "<leader>uu", "<cmd>Undotree<CR>", { desc = "Undo tree" })
