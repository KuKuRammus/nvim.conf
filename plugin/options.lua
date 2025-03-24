-- Options
--

-- Prefer dark colors
vim.o.background = "dark"

-- Use system clipboard
vim.o.clipboard = "unnamedplus"

-- Current line highlight
vim.o.cursorline = true

-- Better colors
if vim.fn.has("termguicolors") == 1 then
    vim.o.termguicolors = true
end

-- Search
vim.o.hlsearch = false -- Remove highlight after search
vim.o.incsearch = true -- Search as you type

-- Minimal amount of lines to keep above/below cursor
vim.o.scrolloff = 10

-- Line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Line wrap
vim.o.wrap = false

-- Keep block cursor everywhere
vim.o.guicursor = ""

-- Whitespace highlight
vim.o.list = true
vim.o.listchars = "trail:~,tab:▹ ,nbsp:_"

-- No idea what it does, but apparently I need to change it
vim.o.updatetime = 500

-- Defult ruler (120)
vim.opt.colorcolumn = "120"

-- Completion menu behavior
vim.o.completeopt = "menuone,noinsert,noselect"

-- Case insensitive search by default, but sensitive if contains at least 1 uppercase
vim.o.ignorecase = true
vim.o.smartcase = true

-- Highlight matching bracket
vim.o.showmatch = true
vim.o.matchtime = 2

-- Default indentation and tab behavior settings
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.expandtab = true

-- Line wrap
vim.o.wrap = false

-- Diagnostic icons
-- See: https://neovim.io/doc/user/diagnostic.html#diagnostic-signs
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
    },
})
