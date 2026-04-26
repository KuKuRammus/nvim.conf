-- Code completion
--

-- blink.cmp - Completion
-- https://github.com/Saghen/blink.cmp
-- https://cmp.saghen.dev/configuration/reference
vim.pack.add({
    { src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("1") }
})

require("blink.cmp").setup({
    keymap = {
        -- [Enter]: Accept selection
        ["<CR>"] = { "accept", "fallback" },

        -- [C-n]: Select next
        ["<C-n>"] = { "select_next", "fallback" },

        -- [C-p]: Select previous
        ["<C-p>"] = { "select_prev", "fallback" },

        -- [C-e]: Close suggestions
        ["<C-e>"] = { "cancel", "fallback" },

        -- [C-d]: Scroll docs down
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },

        -- [C-u]: Scroll docs up
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    },

    -- Use Neovim's built-in vim.snippet engine — no LuaSnip dependency.
    snippets = { preset = "default" },

    completion = {
        list = {
            max_items = 15,
            selection = {
                auto_insert = true,
            },
        },

        accept = {
            auto_brackets = { enabled = true },
        },

        menu = {
            draw = {
                treesitter = { "lsp" },
            },
        },

        documentation = {
            auto_show = true,
            auto_show_delay_ms = 250,
            treesitter_highlighting = true,
        },

        ghost_text = { enabled = false },
    },

    signature = { enabled = true },

    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
            -- Disable in debugger REPL
            ["dap-repl"] = {},
        },
    },

    cmdline = {
        completion = {
            menu = { auto_show = true },
        },
    },
})

-- nvim-autopairs - autopairs
-- https://github.com/windwp/nvim-autopairs
vim.pack.add({ "https://github.com/windwp/nvim-autopairs" })

require("nvim-autopairs").setup({})