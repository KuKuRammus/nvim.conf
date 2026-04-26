-- Code formatting
--

-- gitsigns.nvim - Simple git integration
-- https://github.com/lewis6991/gitsigns.nvim
vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

require("gitsigns").setup({
    on_attach = function(buf)
        local gs = require("gitsigns")

        local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = buf, desc = desc })
        end

        -- []c]: Next hunk (change)
        map("n", "]c", function()
            if vim.wo.diff then
                vim.cmd.normal({ "]c", bang = true })
            else
                gs.nav_hunk("next")
            end
        end, "Next hunk")

        -- [[c]: Previous hunk (change)
        map("n", "[c", function()
            if vim.wo.diff then
                vim.cmd.normal({ "[c", bang = true })
            else
                gs.nav_hunk("prev")
            end
        end, "Previous hunk")

        -- [<leader>gs] Stage hunk under cursor (git add single hunk)
        map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")

        -- [<leader>gu] Undo staged hunk
        map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage")

        -- [<leader>gr] Reset hunk (undo change)
        map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")

        -- [<leader>gp] Preview hunk changes in a floating window
        map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")

        -- [<leader>gb] Blame current line
        map("n", "<leader>gb", gs.blame_line, "Blame line")

        -- [<leader>gd] Show diff against index
        map("n", "<leader>gd", gs.diffthis, "Diff vs index")
    end,
})
