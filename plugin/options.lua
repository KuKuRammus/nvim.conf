-- Editor options
--

-- Dark theme preference
vim.o.background = "dark"

-- True color support
vim.o.termguicolors = true

-- Cursor line highlight
vim.o.cursorline = true

-- Line numbers
vim.o.number = true
vim.o.relativenumber = true

-- No line wrap
vim.o.wrap = false

-- Keep context lines above/below cursor
vim.o.scrolloff = 10

-- Block cursor everywhere (no thin insert cursor)
vim.o.guicursor = ""

-- Column ruler at 120
vim.opt.colorcolumn = "120"

-- Show trailing whitespace and tabs
vim.o.list = true
vim.o.listchars = "trail:~,tab:▹ ,nbsp:_"
vim.opt.fillchars = { eob = " " }   -- hide ~ on empty lines

-- Search behavior
vim.o.hlsearch = false -- Remove highlight after search
vim.o.incsearch = true -- Search as you type

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

-- Clipboard support
vim.o.clipboard = "unnamedplus"

-- Faster CursorHold trigger (affects gitsigns, diagnostics, etc.)
-- Default is 4000ms, lower = more responsive UI updates
vim.o.updatetime = 500

-- Persistent undo
vim.o.undofile = true
vim.o.undolevels = 10000

-- Minimal statusline
vim.o.laststatus = 2
-- vim.o.statusline = " %f %m %= %y  %l:%c  %p%% "

-- Completion menu
vim.o.completeopt = "menuone,noselect,popup"
