-- Code/Action/File system navigation related stuff
--


return {
    -- telescope-fzf-native.nvim - FZF sorter for telescope written in C
    -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
    },

    -- telescope.nvim - Floating picker for a lot of stuff
    -- https://github.com/nvim-telescope/telescope.nvim
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
        },
        config = function ()
            local builtin = require("telescope.builtin")
            local telescope = require("telescope")

            telescope.setup()

            -- Extension: FZF sorter
            telescope.load_extension('fzf')

            -- [<leader>ff]: Search all files (only git files if inside repo)
            vim.keymap.set("n", "<leader>ff", function ()
                local is_repo = vim.fn.system("git rev-parse --is-inside-work-tree"):match("true")
                if is_git_repo then
                    builtin.git_files({ hidden = true })
                else
                    builtin.find_files({ hidded = true })
                end
            end, { desc = "Files" })

            -- [<leader>fr]: List references (lsp)
            vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "List references" })

            -- [<leader>fs]: List document symbols (lsp)
            -- TODO: While this works, ideally, I would rather prefer if struct fields weren't present in this picker
            vim.keymap.set("n", "<leader>fs", function ()
                builtin.lsp_document_symbols({show_line = true})
            end, { desc = "List symbols in current document" })

            -- [<leader>fq]: List quickfix options
            -- TODO: Figure out how does it work?
            vim.keymap.set("n", "<leader>fq", builtin.quickfix, { desc = "List quickfix options" })


            -- view changed files (changed_files)
        end,
    },


    -- oil.nvim - Filesystem navigation and management in buffer-like style
    -- https://github.com/stevearc/oil.nvim
    {
        "stevearc/oil.nvim",
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {},
        config = function ()
            -- Setup
            require("oil").setup({
                -- Columns
                columns = {
                    "icon",
                    "permissions",
                    "size",
                },

                -- Send deleted files to the trash instead of permanently deleting them
                delete_to_trash = true,

                -- View options
                view_options = {
                    -- Show hidden files
                    show_hidden = true,
                },
            });

            -- Keymap
            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" });
        end,
    },
}
