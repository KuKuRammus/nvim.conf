-- tools.php.phpcbf
--
-- Registers a conform.nvim formatter for PHP using phpcbf in a container
--

--- @class PhpcbfSetupOpts
--- @field runtime ComposeServiceDescriptor
--- @field config_file? string                  phpcbf config file (default: phpcs.xml.dist)
--- @field bin_path? string                     Path to phpcbf bin (default: vendor/bin/phpcbf)

local M = {}

local DEFAULT_CONFIG_FILE = "phpcs.xml.dist"
local DEFAULT_BIN_PATH = "vendor/bin/phpcbf"

--- @param opts PhpcbfSetupOpts
function M.setup(opts)
    vim.validate({
        runtime = { opts.runtime, "table" },
        config_file = { opts.config_file, "string", true },
        bin_path = { opts.bin_path, "string", true },
    })

    local config_file = opts.config_file or DEFAULT_CONFIG_FILE
    local bin_path = opts.bin_path or DEFAULT_BIN_PATH
    local runtime = opts.runtime

    if vim.fn.filereadable(runtime.host_root .. "/" .. config_file) ~= 1 then
        vim.notify(string.format("php.phpcbf.setup: %s not found, skipping", config_file), vim.log.levels.WARN)
        return
    end

    local ok, conform = pcall(require, "conform")
    if not ok then
        vim.notify("php.phpcbf.setup: conform.nvim not available", vim.log.levels.ERROR)
        return
    end

    -- ensure no other formatter is setup
    if (conform.formatters_by_ft or {}).php then
        vim.notify("php.phpcbf.setup: another PHP formatter is already registered, skipping", vim.log.levels.WARN)
        return
    end

    -- phpcbf supports stdin via "-" and emits formatted code to stdout
    -- Exit codes: 0 = no fixes needed, 1 = fixes applied (success)
    conform.formatters.phpcbf_docker = {
        command = "docker",
        args = function(_, ctx)
            local container_path = runtime:to_container_path(ctx.filename)
            local cmd = runtime:build_exec_args({
                bin_path,
                "-q",
                "--standard=" .. config_file,
                "--stdin-path=" .. container_path,
                "-",
            })

            return vim.list_slice(cmd, 2)
        end,
        stdin = true,
        cwd = function()
            return runtime.host_root
        end,
        require_cwd = true,
        exit_codes = { 0, 1 },
    }

    local existing = conform.formatters_by_ft or {}
    existing.php = { "phpcbf_docker" }
    conform.formatters_by_ft = existing

    _G.Project:register_tool({
        namespace = "php",
        name = "phpcbf",
        summary = "format on save via phpcbf in " .. runtime.service,
    })
end

return M
