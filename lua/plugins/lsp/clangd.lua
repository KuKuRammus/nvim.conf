-- lsp: C/C++ (clangd)
--

vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--clang-tidy",
		"--header-insertion=never",
		"--completion-style=detailed",
		"--background-index",
	},
	filetypes = { "c", "cpp", "objc", "objcpp" },
	root_markers = {
		"compile_commands.json",
		".clangd",
		".clang-tidy",
		".clang-format",
		"Makefile",
		".git",
	},
})
