-- Editor options
--

-- Dark theme preference
vim.o.background = "dark"

-- Clipboard support
vim.o.clipboard = "unnamedplus"

-- Cursor line highlight
vim.o.cursorline = true

-- True color support
vim.o.termguicolors = true

-- Search behavior
vim.o.hlsearch = false -- Remove highlight after search
vim.o.incsearch = true -- Search as you type

-- Keep context lines above/below cursor
vim.o.scrolloff = 10

-- Line numbers
vim.o.number = true
vim.o.relativenumber = true

-- No line wrap
vim.o.wrap = false

-- Block cursor everywhere (no thin insert cursor)
vim.o.guicursor = ""

-- Show trailing whitespace and tabs
vim.o.list = true
vim.o.listchars = "trail:~,tab:▹ ,nbsp:_"

-- Faster CursorHold trigger (affects gitsigns, diagnostics, etc.)
-- Default is 4000ms, lower = more responsive UI updates
vim.o.updatetime = 500

-- Column ruler at 120
vim.opt.colorcolumn = "120"

-- Completion menu
vim.o.completeopt = "menuone,noinsert,noselect"

-- Smart case search (insensitive by default, but sensitive if have at least 1 uppercase)
vim.o.ignorecase = true
vim.o.smartcase = true

-- Highlight matching bracket
vim.o.showmatch = true
vim.o.matchtime = 2

-- Default indentation: 4 spaces
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.expandtab = true

-- Diagnostic appearance
vim.diagnostic.config({
	virtual_text = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "E",
			[vim.diagnostic.severity.WARN] = "W",
			[vim.diagnostic.severity.INFO] = "I",
			[vim.diagnostic.severity.HINT] = "H",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

-- Minimal statusline
vim.o.laststatus = 2
vim.o.statusline = " %f %m %= %y  %l:%c  %p%% "
