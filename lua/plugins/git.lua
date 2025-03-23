-- Git related stuff
--

return {
    -- gitsigns.nvim - Simple git integration
    -- https://github.com/lewis6991/gitsigns.nvim
    {
        "lewis6991/gitsigns.nvim",
        config = function ()
            local gitsigns = require("gitsigns")

            gitsigns.setup({
                on_attach = function (buf)
                    -- TODO: https://github.com/lewis6991/gitsigns.nvim?tab=readme-ov-file#-keymaps

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = buf
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- [ ]c ]: Next hunk (change)
                    map('n', ']c', function()
                        if vim.wo.diff then
                            vim.cmd.normal({']c', bang = true})
                        else
                            gitsigns.nav_hunk('next')
                        end
                    end)

                    -- [ [c ]: Previous hunk (change)
                    map('n', '[c', function()
                        if vim.wo.diff then
                            vim.cmd.normal({'[c', bang = true})
                        else
                            gitsigns.nav_hunk('prev')
                        end
                    end)

                    -- [<leader><leader>gd]: Show diff
                    map("n", "<leader><leader>gd", gitsigns.diffthis, { desc = "git diff" })
                end,
            })
        end,
    }
}
