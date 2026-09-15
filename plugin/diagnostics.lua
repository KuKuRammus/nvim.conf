-- LSP Diagnostics
--

vim.diagnostic.config({
    virtual_lines = {
        current_line = true, -- only show on the cursor's current line (set false to show at every line)
    },
    virtual_text = false, -- mutually exclusive with virtual_lines for sanity
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "e",
            [vim.diagnostic.severity.WARN] = "w",
            [vim.diagnostic.severity.INFO] = "i",
            [vim.diagnostic.severity.HINT] = "h",
        },
    },
    float = {
        border = "rounded",
        source = true,
    },
})

-- [<leader>ud] Toggle between virtual_lines and nothing (handy when virtual_lines is too loud)
vim.keymap.set("n", "<leader>ud", function()
    local cfg = vim.diagnostic.config()
    vim.diagnostic.config({ virtual_lines = not cfg.virtual_lines })
end, { desc = "Toggle diagnostics" })
