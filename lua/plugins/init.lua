-- Plugins
require("plugins.theme")
require("plugins.treesitter")
require("plugins.completion")
require("plugins.formatting")
require("plugins.linting")
require("plugins.navigation")
require("plugins.git")
require("plugins.debugging")
require("plugins.misc")

-- LSP: enable servers
vim.lsp.enable({ "gopls", "clangd", "lua_ls", "intelephense" })

local function installed_plugin_names()
    local names = {}

    for _, p in ipairs(vim.pack.get()) do
        names[#names + 1] = p.spec.name
    end

    return names
end

-- :PackUpdate - opens a buffer showing pending updates per plugin
-- Review the diff. Save the buffer (`:w`) to apply, or close it (`:q`) to cancel
vim.api.nvim_create_user_command("PackUpdate", function(opts)
    local names = #opts.fargs > 0 and opts.fargs or installed_plugin_names()
    vim.pack.update(names)
end, {
    desc = "Check for and apply plugin updates (interactive)",
    nargs = "*",
    complete = function()
        return installed_plugin_names()
    end,
})

-- :PackStatus - show currently installed versions
vim.api.nvim_create_user_command("PackStatus", function()
    for _, p in ipairs(vim.pack.get()) do
        print(string.format("%-30s %s", p.spec.name, p.active and "[loaded]" or "[opt]"))
    end
end, { desc = "List installed plugins" })

-- PackClean - remove plugins no longer in any vim.pack.add list
vim.api.nvim_create_user_command("PackClean", function()
    -- Plugins on disk but not added in this session = unused
    local unused = {}
    for _, p in ipairs(vim.pack.get()) do
        if not p.active then
            unused[#unused + 1] = p.spec.name
        end
    end
    if #unused == 0 then
        vim.notify("No unused plugins")
        return
    end
    vim.pack.del(unused)
end, { desc = "Remove unused plugins" })

-- Experimental: UI2
-- https://neovim.io/doc/user/lua/#ui2
pcall(function()
    require("vim._core.ui2").enable()
end)
