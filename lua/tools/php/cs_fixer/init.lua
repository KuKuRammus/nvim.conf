-- tools.php.cs_fixer
--
-- Registers a conform.nvim formatter for PHP using php-cs-fixer in a container
-- Uses temp file mode (php-cs-fixer 3.x stdin doesn't emit formatted output to stdout)
-- Path is translated host -> container before invocation
--

--- @class PhpCsFixerSetupOpts
--- @field runtime ComposeServiceDescriptor    Runtime (composer service only for now)
--- @field config_file? string                  Filename defining formatter settings (default: .php-cs-fixer.dist.php)
--- @field bin_path? string                     Path to php-cs-fixer bin (default: vendor/bin/php-cs-fixer)

local M = {}

local DEFAULT_CONFIG_FILE = ".php-cs-fixer.dist.php"
local DEFAULT_BIN_PATH = "vendor/bin/php-cs-fixer"

--- Register formatter with conform.nvim and wire to PHP filetype
--- @param opts PhpCsFixerSetupOpts
function M.setup(opts)
    vim.validate({
        runtime = { opts.runtime, "table" },
        config_file = { opts.config_file, "string", true },
        bin_path = { opts.bin_path, "string", true },
    })

    local config_file = opts.config_file or DEFAULT_CONFIG_FILE
    local bin_path = opts.bin_path or DEFAULT_BIN_PATH
    local runtime = opts.runtime

    -- Soft fail if the cs-fixer config doesn't exist in the project
    if vim.fn.filereadable(runtime.host_root .. "/" .. config_file) ~= 1 then
        vim.notify(string.format("php.cs_fixer.setup: %s not found, skipping", config_file), vim.log.levels.WARN)
        return
    end

    -- Resolve conform.nvim
    local ok, conform = pcall(require, "conform")
    if not ok then
        vim.notify("php.cs_fixer.setup: conform.nvim is not available", vim.log.levels.WARN)
        return
    end

    -- ensure no other formatter is setup
    if (conform.formatters_by_ft or {}).php then
        vim.notify("php.cs_fixer.setup: another PHP formatter is already registered, skipping", vim.log.levels.WARN)
        return
    end

    -- Define formatter. Temp-file mode; conform writes the buffer to
    -- <dir>/.conform.N.<filename>, runs cs-fixer on it, reads back
    -- Path translation maps that temp file to its container path
    conform.formatters.php_cs_fixer_docker = {
        command = "docker",
        args = function(_, ctx)
            local cmd = runtime:build_exec_args({
                bin_path,
                "fix",
                "--using-cache=no",
                "--quiet",
                runtime:to_container_path(ctx.filename),
            })

            -- drop "docker" prefix from generated command, since conform.nvim will auto append it
            return vim.list_slice(cmd, 2)
        end,
        stdin = false,
        cwd = function()
            return runtime.host_root
        end,
        require_cwd = true,
        exit_codes = { 0, 8 },
    }

    -- Patch formatters_by_ft to include PHP
    local existing = conform.formatters_by_ft or {}
    existing.php = { "php_cs_fixer_docker" }
    conform.formatters_by_ft = existing

    if _G.Project then
        _G.Project:register_tool({
            namespace = "php",
            name = "cs_fixer",
            summary = string.format("format on save via php-cs-fixer in %s", runtime.service),
        })
    end
end

return M
