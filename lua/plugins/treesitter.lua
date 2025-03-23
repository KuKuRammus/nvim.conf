-- Treesitter and related stuff
--

return {
    -- nvim-treesitter - Treesitter
    -- https://github.com/nvim-treesitter/nvim-treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function ()
            require("nvim-treesitter.configs").setup({
                -- Ensure these are supported
                ensure_installed = {
                    "bash",
                    "c",
                    "cmake",
                    "cpp",
                    "css",
                    "dockerfile",
                    "elixir",
                    "erlang",
                    "go",
                    "gomod",
                    "gowork",
                    "html",
                    "javascript",
                    "json",
                    "lua",
                    "make",
                    "markdown",
                    "php",
                    "python",
                    "regex",
                    "scss",
                    "toml",
                    "typescript",
                    "tsx",
                    "twig",
                    "vim",
                    "xml",
                    "yaml",
                },

                -- Flag if sync plugin install must be used, when installing 'ensure_installed'
                sync_install = false,

                -- Flag if missing plugins are auto-installed on buffer open
                auto_install = false,

                -- Enable indentation support
                indent = { enable = true },

                -- Highlighting option
                highlight = {
                    enable = true,

                    -- Do not highlight large files
                    disable = function(lang, buf)
                        -- 100 KB
                        local max_filesize = 100 * 1024
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            return true
                        end
                    end,

                    -- Disable additional highlighting from vim
                    addtional_vim_regex_highlighting = false,
                },
            })
        end,
    }
}
