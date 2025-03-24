-- LSP
--

-- Attaches LSP related keymap to a buffer
-- TODO: Add description to the keymaps
local function keymap_init(buf)
    local opts = { noremap = true, silent = true, buffer = buf }

    -- [gd]: To to definition
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

    -- [gr]: Show references
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

    -- [gi]: Jump to implementation
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

    -- [K]: Hover
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

    -- [Ctrl+k]: Show signature
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

    -- [gn]: Rename symbol
    vim.keymap.set("n", "gn", vim.lsp.buf.rename, opts)

    -- [ ]x ]: Diagnostic next
    vim.keymap.set("n", "]x", function () vim.diagnostic.goto_next({ float = false }) end, opts)

    -- [ [x ]: Diagnostic prev
    vim.keymap.set("n", "[x", function () vim.diagnostic.goto_prev({ float = false }) end, opts)

end

return {
    -- nvim-lspconfig - Quickstart LSP configs
    -- https://github.com/neovim/nvim-lspconfig
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "saghen/blink.cmp",
        },
        config = function ()
            local lspconfig = require("lspconfig")

            -- Completion capabilities
            local capabilities = require("blink.cmp").get_lsp_capabilities()


            --
            -- Go (gopls)
            --
            lspconfig.gopls.setup({
                capabilities = vim.tbl_deep_extend(
                    "force",
                    {},
                    capabilities,
                    lspconfig.gopls.capabilities or {}
                ),

                -- Docs: https://go.googlesource.com/vscode-go/+/HEAD/docs/settings.md#settings-for
                -- Lazyvim version: https://www.lazyvim.org/extras/lang/go
                settings = {
                    gopls = {
                        gofumpt = true,
                        analyses = {
                            fieldalignment = false,
                            nilness = true,
                            unusedparams = true,
                            unusedwrite = true,
                            useany = true,
                        },
                        codelenses = {
                            gc_details = false,
                            generate = true,
                            regenerate_cgo = true,
                            run_govulncheck = true,
                            test = true,
                            tidy = true,
                            upgrade_dependency = true,
                            vendor = true,
                            -- vulncheck = true,
                        },
                        experimentalPostfixCompletions = true,
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            compositeLiteralTypes = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true
                        },
                        usePlaceholders = true,
                        completeUnimported = true,
                        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                        semanticTokens = true,
                    },
                },

                on_attach = function (client, buf)
                    keymap_init(buf)

                    -- workaround for gopls not supporting semanticTokensProvider
                    -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
                    if not client.server_capabilities.semanticTokensProvider then
                        local semantic = client.config.capabilities.textDocument.semanticTokens
                        client.server_capabilities.semanticTokensProvider = {
                            full = true,
                            legend = {
                                tokenTypes = semantic.tokenTypes,
                                tokenModifiers = semantic.tokenModifiers,
                            },
                            range = true,
                        }
                    end
                end,
            })


            --
            -- C/C++ (clangd)
            --
            lspconfig.clangd.setup({
                capabilities = vim.tbl_deep_extend(
                    "force",
                    {},
                    capabilities,
                    lspconfig.clangd.capabilities or {}
                ),

                cmd = {
                    'clangd',
                    '--clang-tidy',
                    '--header-insertion=never',
                    '--completion-style=detailed',
                    '--background-index',
                },

                filetypes = {'c', 'cpp', 'objc', 'objcpp'},

                on_attach = function (_, buf)
                    keymap_init(buf)
                end
            })

            --
            -- TypeScript / JavaScript
            --
            lspconfig.ts_ls.setup({
                capabilities = vim.tbl_deep_extend(
                    "force",
                    {},
                    capabilities,
                    lspconfig.ts_ls.capabilities or {}
                ),

                filetypes = {
                    "typescript",
                    "javascript",
                    "typescriptreact",
                    "javascriptreact",
                },

                cmd = { "typescript-language-server", "--stdio" },

                settings = {
                    typescript = { inlayHints = { includeInlayParameterNameHints = "all" } },
                    javascript = { inlayHints = { includeInlayParameterNameHints = "all" } },
                },

                init_options = {
                    init_options = {
                        preferences = {
                            -- https://github.com/sublimelsp/LSP-typescript/issues/129#issuecomment-1281643371
                            includeCompletionsForModuleExports = false,
                        }
                    }
                },

                on_attach = function(client, buf)
                    -- Use conform.nvim for formatting instead built in one
                    client.server_capabilities.documentFormattingProvider = false
                    keymap_init(buf)
                end,
            })
        end,
    }
}
