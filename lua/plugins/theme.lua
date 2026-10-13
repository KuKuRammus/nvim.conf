-- Theme / Colors
--

vim.cmd.colorscheme("ayu")
vim.o.winborder = "rounded" -- popups sit on the editor background; the border separates them

vim.api.nvim_create_user_command("AyuCompile", function()
    local path, count = require("themes.ayu").compile()
    vim.notify(("ayu: compiled %d groups to %s"):format(count, path))
end, {})
