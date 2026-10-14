-- Theme / Colors
--

vim.cmd.colorscheme("sumi")
vim.o.winborder = "rounded" -- popups sit on the editor background; the border separates them

vim.api.nvim_create_user_command("SumiCompile", function()
    local path, count = require("themes.sumi").compile()
    vim.notify(("ayu: compiled %d groups to %s"):format(count, path))
end, {})
