-- tools.php.phpcs
--
-- Registers an nvim-lint linter for PHP using phpcs in a container
-- Streams buffer content via stdin; translates host buffer path to container
-- path for --stdin-path. Parses phpcs JSON output directly
--

--- @class PhpcsSetupOpts
--- @field runtime ComposerServiceDescriptor    Docker compose service
--- @field config_file? string                  Linter config file (default: phpcs.xml.dist)
--- @field trigger_events? string[]             Events to tigger lint on (default: "BufWritePost", "InsertLeave")
--- @field bin_path? string                     Path to phpcs bin (default: vendor/bin/phpcs)
--- @field user_cmd_name? string                Vim user command name (default: :Phpcs)

local shared = require("tools._shared")

local M = {}

local DEFAULT_CONFIG_FILE = "phpcs.xml.dist"
local DEFAULT_TRIGGER_EVENTS = { "BufWritePost", "InsertLeave" }
local DEFAULT_BIN_PATH = "vendor/bin/phpcs"
local DEFAULT_USER_CMD_NAME = "Phpcs"

--- @param raw string|nil
--- @param bufnr integer
--- @return table[]
local function parse(raw, bufnr)
    local decoded = shared.decode_json(raw)
    if decoded == nil or type(decoded) ~= "table" or type(decoded.files) ~= "table" then
        return {}
    end

    local severity_map = {
        ERROR = vim.diagnostic.severity.ERROR,
        WARNING = vim.diagnostic.severity.WARN,
    }

    local diagnostics = {}
    for _, file_data in pairs(decoded.files) do
        for _, msg in ipairs(file_data.messages or {}) do
            local lnum = (msg.line or 1) - 1
            local col = (msg.column or 1) - 1
            table.insert(diagnostics, {
                bufnr = bufnr,
                lnum = lnum,
                col = col,
                end_lnum = lnum,
                end_col = col,
                severity = severity_map[msg.type] or vim.diagnostic.severity.WARN,
                message = msg.message or "",
                source = "phpcs",
                code = msg.source,
            })
        end
    end

    return diagnostics
end

--- Register phpcs as a linter for PHP buffers
--- @param opts PhpcsSetupOpts
function M.setup(opts)
    vim.validate({
        runtime = { opts.runtime, "table" },
        config_file = { opts.config_file, "string", true },
        trigger_events = { opts.trigger_events, "table", true },
        bin_path = { opts.bin_path, "string", true },
        user_cmd_name = { opts.user_cmd_name, "string", true },
    })

    local config_file = opts.config_file or DEFAULT_CONFIG_FILE
    local trigger_events = opts.trigger_events or DEFAULT_TRIGGER_EVENTS
    local bin_path = opts.bin_path or DEFAULT_BIN_PATH
    local user_cmd_name = opts.user_cmd_name or DEFAULT_USER_CMD_NAME
    local runtime = opts.runtime

    if vim.fn.filereadable(runtime.host_root .. "/" .. config_file) ~= 1 then
        vim.notify(string.format("php.phpcs.setup: %s not found, skipping", config_file), vim.log.levels.WARN)
        return
    end

    -- resolve nvim-lint
    local ok, lint = pcall(require, "lint")
    if not ok then
        vim.notify("php.phpcs.setup: nvim-lint not available", vim.log.levels.ERROR)
        return
    end

    -- Static specs; args are mutated per buffer right before each invocation
    -- (function-typed args breaks an internal nvim-lint deepcopy path.)
    lint.linters.phpcs_docker = {
        cmd = "docker",
        stdin = true,
        stream = "stdout",
        ignore_exitcode = true,
        args = {},
        parser = parse,
    }

    -- autocmd: build args from current buffer, run linter for php only
    local group = vim.api.nvim_create_augroup("tools-php-phpcs", { clear = true })
    vim.api.nvim_create_autocmd(trigger_events, {
        group = group,
        callback = function(args)
            if vim.bo[args.buf].filetype ~= "php" then
                return
            end

            local bufname = vim.api.nvim_buf_get_name(args.buf)
            if bufname == "" then
                return
            end

            local container_path = runtime:to_container_path(bufname)
            local cmd = runtime:build_exec_args({
                bin_path,
                "-q",
                "--report=json",
                "--stdin-path=" .. container_path,
                "--standard=" .. config_file,
                "-",
            })

            -- Drop leading docker; "nvim-lint" will prefix it automatically
            lint.linters.phpcs_docker.args = vim.list_slice(cmd, 2)
            lint.try_lint("phpcs_docker")
        end,
    })

    -- add user command
    vim.api.nvim_create_user_command(user_cmd_name, function(cmd_opts)
        local cmd = {
            bin_path,
            "-q",
            "--report=json",
            "--no-cache",
            "--standard=" .. config_file,
        }

        if cmd_opts.args ~= "" then
            table.insert(cmd, runtime:to_container_path(vim.fn.fnamemodify(cmd_opts.args, ":p")))
        end

        vim.notify("Running phpcs...", vim.log.levels.INFO)
        runtime:exec_async(cmd, function(result)
            local decoded = shared.decode_json(result.stdout)
            if not decoded then
                vim.notify(
                    string.format(
                        "phpcs: failed (exit %s)\nstdout: %s\nstderr: %s",
                        tostring(result.code),
                        (result.stdout or ""):sub(1, 500),
                        result.stderr or ""
                    ),
                    vim.log.levels.ERROR
                )
                return
            end

            local items = {}
            for file, file_data in pairs(decoded.files or {}) do
                local host_path = runtime:to_host_path(file)
                for _, msg in ipairs(file_data.messages or {}) do
                    table.insert(items, {
                        filename = host_path,
                        lnum = msg.line or 1,
                        col = msg.column or 1,
                        text = (msg.source or "") .. ":" .. (msg.message or ""),
                        type = msg.type == "ERROR" and "E" or "W",
                    })
                end
            end

            shared.set_quickfix("phpcs", items)
        end)
    end, {
        nargs = "?",
        complete = "file",
        desc = "Run phpcs project-wide (optionally scoped to path)",
    })

    _G.Project:register_tool({
        namespace = "php",
        name = "phpcs",
        summary = string.format("php linting via phpcs in %s", runtime.service),
    })
end

return M
