-- Code formatting
--

-- conform.nvim - Formatter
-- https://github.com/stevearc/conform.nvim
vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

local conform = require("conform")

-- Find nearest docker-compose file
local find_compose_root = function(ctx)
    local found = vim.fs.find({ "docker-compose.yml", "docker-compose.yaml", "compose.yml" }, {
        upward = true,
        path = ctx.dirname,
        stop = vim.loop.os_homedir(),
    })[1]

    return found and vim.fs.dirname(found) or nil
end

conform.formatters.php_cs_fixer_docker = {
    command = "docker",
    args = function(_, ctx)
        local root = find_compose_root(ctx) or vim.fn.getcwd()
        local container_path = ctx.filename:gsub(vim.pesc(root), "/data/app")
        return {
            "compose",
            "exec",
            "-T",
            "app",
            "vendor/bin/php-cs-fixer",
            "fix",
            "--using-cache=no",
            "--quiet",
            container_path,
        }
    end,
    stdin = false,
    cwd = find_compose_root,
    require_cwd = true,
    condition = function(_, ctx)
        local root = find_compose_root(ctx)
        if not root then
            return false
        end
        return vim.fn.filereadable(root .. "/.php-cs-fixer.dist.php") == 1
            or vim.fn.filereadable(root .. "/.php-cs-fixer.php") == 1
    end,
    exit_codes = { 0, 8 },
}

conform.setup({
    formatters_by_ft = {
        go = { "goimports", "goimports-reviser" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        lua = { "stylua" },
        php = { "php_cs_fixer_docker" },
    },

    format_on_save = {
        timeout_ms = 5000,
        lsp_format = "fallback",
    },
})
