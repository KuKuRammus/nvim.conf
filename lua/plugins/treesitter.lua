-- Treesitter
--

return {
	-- nvim-treesitter - Treesitter
	-- https://github.com/nvim-treesitter/nvim-treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"c",
					"cmake",
					"cpp",
					"css",
					"dockerfile",
					"go",
					"gomod",
					"gosum",
					"gowork",
					"html",
					"javascript",
					"json",
					"lua",
					"luadoc",
					"make",
					"markdown",
					"markdown_inline",
					"php",
					"python",
					"query",
					"regex",
					"scss",
					"toml",
					"tsx",
					"typescript",
					"vim",
					"vimdoc",
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
					disable = function(_, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,

					-- Disable additional highlighting from vim
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},
}
