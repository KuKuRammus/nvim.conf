-- Status line
--

return {
    -- lualine.nvim - Status line
    -- https://github.com/nvim-lualine/lualine.nvim
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "UIEnter",
        config = function()
            local lualine = require("lualine")

            lualine.setup({})
        end,
    },
}
