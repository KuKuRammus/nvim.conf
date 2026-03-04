-- Theme / Colors
--

return {
	-- kanagawa.nvim
	-- https://github.com/rebelot/kanagawa.nvim
	{
		"rebelot/kanagawa.nvim",
		build = ":KanagawaCompile",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa").setup({ compile = true })
			require("kanagawa").load("wave")
		end,
	},
}
