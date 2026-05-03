-- Encoding
vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Per project .nvim.lua
vim.o.exrc = true

require("project")

-- Plugins
require("plugins")
