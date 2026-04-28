-- Linting
--

-- nvim-lint - Linter
-- https://github.com/mfussenegger/nvim-lint
vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })

local lint = require("lint")

-- Find nearest docker-compose project root by walking up from current buffer.
local find_compose_root = function(bufnr)
    local file = vim.api.nvim_buf_get_name(bufnr or 0)
    local dir = file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()
    local found = vim.fs.find({ "docker-compose.yml", "docker-compose.yaml", "compose.yml" }, {
        upward = true,
        path = dir,
        stop = vim.loop.os_homedir(),
    })[1]
    return found and vim.fs.dirname(found) or nil
end

-- phpcs severity strings -> nvim diagnostic severities.
local severity_map = {
    ERROR = vim.diagnostic.severity.ERROR,
    WARNING = vim.diagnostic.severity.WARN,
}

-- Custom phpcs linter running inside the docker compose `app` container.
-- - Streams buffer content via stdin.
-- - Translates host buffer path -> container path for --stdin-path.
-- - Parses phpcs JSON output directly.
-- args is mutated imperatively before each invocation (function-typed args
-- breaks an internal nvim-lint deepcopy/extend path on this version).
lint.linters.phpcs_docker = {
    cmd = "docker",
    stdin = true,
    stream = "stdout",
    ignore_exitcode = true,
    args = {},
    parser = function(output, _)
        if output == nil or output == "" then
            return {}
        end
        local ok, decoded = pcall(vim.json.decode, output)
        if not ok or type(decoded) ~= "table" or type(decoded.files) ~= "table" then
            return {}
        end
        local diagnostics = {}
        for _, file_data in pairs(decoded.files) do
            for _, msg in ipairs(file_data.messages or {}) do
                table.insert(diagnostics, {
                    lnum = (msg.line or 1) - 1,
                    col = (msg.column or 1) - 1,
                    end_lnum = (msg.line or 1) - 1,
                    end_col = (msg.column or 1) - 1,
                    severity = severity_map[msg.type] or vim.diagnostic.severity.WARN,
                    message = msg.message or "",
                    source = "phpcs",
                    code = msg.source,
                })
            end
        end
        return diagnostics
    end,
}

lint.linters_by_ft = {
    go = { "golangcilint" },
    lua = { "luacheck" },
    php = { "phpcs_docker" },
}

-- For PHP buffers in a dockerized project: compute container path, set args,
-- then run phpcs_docker explicitly. Other filetypes go through normal resolution.
local function lint_php()
    local bufname = vim.api.nvim_buf_get_name(0)
    local root = find_compose_root() or vim.fn.getcwd()
    local container_path = bufname:gsub(vim.pesc(root), "/data/app")
    lint.linters.phpcs_docker.args = {
        "compose",
        "exec",
        "-T",
        "app",
        "vendor/bin/phpcs",
        "-q",
        "--report=json",
        "--stdin-path=" .. container_path,
        "-",
    }
    lint.try_lint("phpcs_docker")
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
    callback = function()
        if vim.bo.filetype == "php" then
            if find_compose_root() then
                lint_php()
            end
        else
            lint.try_lint()
        end
    end,
})
