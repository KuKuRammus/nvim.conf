-- Code completion
--

-- blink.cmp - Completion
-- https://github.com/Saghen/blink.cmp
-- https://main.cmp.saghen.dev/configuration/reference.html
vim.pack.add({ "https://github.com/saghen/blink.lib", "https://github.com/saghen/blink.cmp" })

local cmp = require("blink.cmp")
cmp.build():pwait()
cmp.setup({
    keymap = {
        -- [Enter]: Accept selection
        ["<CR>"] = { "accept", "fallback" },
    },

    completion = {
        list = {
            max_items = 15,
            selection = {
                preselect = true,
                auto_insert = false,
            },
        },

        menu = {
            draw = {
                treesitter = { "lsp" },
            },
        },
    },

    signature = {
        enabled = true,
    },

    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
            -- Disable in debugger REPL
            ["dap-repl"] = {},
        },
    },
})

-- nvim-autopairs - autopairs
-- https://github.com/windwp/nvim-autopairs
vim.pack.add({ "https://github.com/windwp/nvim-autopairs" })

require("nvim-autopairs").setup({})
