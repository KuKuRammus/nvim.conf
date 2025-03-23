-- Theme / Colors
--

return {
    -- kanagawa.nvim
    -- https://github.com/rebelot/kanagawa.nvim
    {
        "rebelot/kanagawa.nvim",
        build = ":KanagawaCompile",
        lazy = false,
        config = function ()
            local theme = require("kanagawa")
            theme.setup({
                compile = true,
            })
            theme.load("wave")
        end
    }
}
