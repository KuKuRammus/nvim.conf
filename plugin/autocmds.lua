-- Autocommands
--

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ timeout = 250 })
    end,
})

-- LSP keymaps + features
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(event)
        local buf = event.buf
        local opts = { noremap = true, silent = true, buffer = buf }
        local map = vim.keymap.set

        -- Navigation
        -- [gd] - Go to definition
        -- [gD] - Go to declaration (different from definition for C headers)
        -- [gi] - Go to implementation
        -- [gr] - Show references
        map("n", "gd", vim.lsp.buf.definition, opts)
        map("n", "gD", vim.lsp.buf.declaration, opts)
        map("n", "gi", vim.lsp.buf.implementation, opts)
        map("n", "gr", vim.lsp.buf.references, opts)
        -- TODO: Might use fzf for references
        -- map("n", "gr", function()
        --     require("fzf-lua").lsp_references()
        -- end, opts)

        -- Info
        -- [K] Hover documentation
        -- [Ctrl-k] Signature help
        map("n", "K", vim.lsp.buf.hover, opts)
        map("n", "<C-k>", vim.lsp.buf.signature_help, opts)

        -- Refactor
        -- [gn] Rename symbol
        -- [ga] Code actions (quick fixes, refactors, etc)
        map("n", "gn", vim.lsp.buf.rename, opts)
        map("n", "ga", vim.lsp.buf.code_action, opts)

        -- Diagnostics
        -- []x] Diagnostic navigation - next
        -- [[x] Diagnostic navigation - prev
        map("n", "]x", function()
            vim.diagnostic.jump({ count = 1, float = false })
        end, opts)
        map("n", "[x", function()
            vim.diagnostic.jump({ count = -1, float = false })
        end, opts)
    end,
})

-- Auto-start treesitter highlighting + indent for any installed parser
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then
            return
        end

        -- pcall returns (true, return_value); language.add returns truthy
        -- only when the parser actually loaded
        local ok, has_parser = pcall(vim.treesitter.language.add, lang)
        if not ok or not has_parser then
            return
        end

        -- Skip very large files
        local stat_ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
        if stat_ok and stats and stats.size > 100 * 1024 then
            return
        end

        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        vim.treesitter.start(args.buf)
    end,
})

-- Quick-close help/quickfix/etc with q
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("quick-close", { clear = true }),
    pattern = { "help", "qf", "lspinfo", "checkhealth" },
    callback = function(event)
        vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
    end,
})
