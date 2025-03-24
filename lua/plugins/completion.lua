-- Code completion
--

return {
    -- LuaSnip - Snippet engine
    -- https://github.com/L3MON4D3/LuaSnip
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        config = function ()
            local ls = require("luasnip")
            ls.setup({
                update_events = { "TextChanged", "TextChangedI" },
            })

            -- [Ctrl+k]: Jump to next node
            vim.keymap.set({ "i", "s" }, "<C-k>", function ()
                if ls.expand_or_jumpable() then
                    ls.expand_or_jump()
                end
            end, { silent = true, desc = "Jump to next node" })

            -- [Ctrlj]: Jump to previous node
            vim.keymap.set({ "i", "s" }, "<C-j>", function()
                if ls.jumpable(-1) then
                    ls.jump(-1)
                end
            end, { silent = true, desc = "Jump to previous node" })

            -- TODO: Load snippets from directory
            -- require("luasnip.loaders.from_lua").load({ paths = "~/.snippets" })
        end,
    },

    -- blink.cmp - Completion
    -- https://github.com/Saghen/blink.cmp
    {
        "saghen/blink.cmp",
        dependencies = {
            "L3MON4D3/LuaSnip",
        },
        version = "*",

        -- Docs: https://cmp.saghen.dev/configuration/reference
        opts = {
            keymap = { preset = "enter" },
            snippets = { preset = "luasnip" },
            completion = {
                list = {
                    max_items = 15,
                    selection = {
                        auto_insert = true,
                    }
                },
                accept = { auto_brackets = { enabled = true } },
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
                -- Options: "lsp", "path", "snippets", "buffer"
                default = {},
                per_filetype = {
                    go = { "lsp", "snippets" },
                    gitcommit = {},
                    typescriptreact = { "lsp", "snippets" },
                    typescript = { "lsp", "snippets" },
                },
            },
            appearance = {
                use_nvim_cmp_as_default = true,
            },
            cmdline = {
                completion = {
                    menu = { auto_show = true },
                },
            },
        },
        opts_extend = { "sources.default" },
    },

    -- nvim-autopairs - autopairs
    -- https://github.com/windwp/nvim-autopairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },
}
