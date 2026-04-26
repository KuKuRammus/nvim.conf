-- lsp: Go (gopls)
--

return {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gosum", "gowork" },
    root_markers = { "go.mod", ".git" },
    settings = {
        gopls = {
            gofumpt = true,
            analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
            },
            codelenses = {
                generate = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
            },
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
            directoryFilters = {
                "-.git",
                "-.vscode",
                "-.idea",
                "-node_modules",
            },
            semanticTokens = true,
        },
    },
}
