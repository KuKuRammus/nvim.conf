-- File type detection rules
-- Use `vim.filetype.add(...)` function to setup new file types detection rules
-- See: https://neovim.io/doc/user/lua.html#vim.filetype.add()

vim.filetype.add({
    extension = {
        -- C
        c = "c",
        h = "c",

        -- C++
        cpp = "cpp",
        hpp = "hpp",
    },
})
