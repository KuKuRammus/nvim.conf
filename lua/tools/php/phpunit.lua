-- tools.php.phpunit
--
-- Registers :Phpunit [path] user command. Runs PHPUnit in a terminal split
-- inside the container so colore output and progress dots render
--

--- @class PhpunitSetupOpts
--- @field runtime ComposeServiceDescriptor
--- @field config_file? string      Config file (default: phpunit.dist.xml)
--- @field bin_path? string         Path to phpunit bin (default: vendor/bin/phpunit)
--- @field user_cmd_name? string    Vim user command name (default: :Phpunit)
---

local M = {}

local DEFAULT_CONFIG_FILE = "phpunit.dist.xml"
local DEFAULT_BIN_PATH = "vendor/bin/phpunit"
local DEFAULT_USER_COMMAND_NAME = "Phpunit"

--- @param opts PhpunitSetupOpts
function M.setup(opts)
    vim.validate({
        runtime = { opts.runtime, "table" },
        config_file = { opts.config_file, "string", true },
        bin_path = { opts.bin_path, "string", true },
        user_cmd_name = { opts.user_cmd_name, "string", true },
    })

    -- Resolve settings
    local config_file = opts.config_file or DEFAULT_CONFIG_FILE
    local bin_path = opts.bin_path or DEFAULT_BIN_PATH
    local user_cmd_name = opts.user_cmd_name or DEFAULT_USER_COMMAND_NAME
    local runtime = opts.runtime

    -- Ensure config file present
    if vim.fn.filereadable(runtime.host_root .. "/" .. config_file) ~= 1 then
        vim.notify(string.format("php.phpunit.setup: %s not found, skipping", config_file), vim.log.levels.WARN)
        return
    end

    -- Register command
    vim.api.nvim_create_user_command(user_cmd_name, function(cmd_opts)
        local cmd = bin_path
        if cmd_opts.args ~= "" then
            local container_path = runtime:to_container_path(vim.fn.fnamemodify(cmd_opts.args, ":p"))
            cmd = cmd .. " " .. vim.fn.shellescape(container_path)
        end

        runtime:exec_terminal(cmd)
    end, {
        nargs = "?",
        complete = "file",
        desc = "Run PHPUnit (optionally scoped to a path)",
    })

    if _G.Project then
        _G.Project:register_tool({
            namespace = "php",
            name = "phpunit",
            summary = string.format(":%s command, runs in %s", user_cmd_name, runtime.service),
        })
    end
end

return M
