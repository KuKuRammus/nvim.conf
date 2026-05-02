-- tools.php.phpunit
--
-- Registers :Phpunit [path] user command. Runs PHPUnit in a terminal split
-- inside the container so colore output and progress dots render
--

--- @class PhpunitSetupOpts
--- @field runtime ComposerServiceDescriptor
--- @field config_file? string  Config file (default: phpunit.dist.xml)
---

local M = {}

local COMMAND_NAME = "Phpunit"

local DEFAULT_CONFIG_FILE = "phpunit.dist.xml"

--- @param opts PhpunitSetupOpts
function M.setup(opts)
    vim.validate({
        runtime = { opts.runtime, "table" },
        config_file = { opts.config_file, "string", true },
    })

    local config_file = opts.config_file or DEFAULT_CONFIG_FILE
    local runtime = opts.runtime

    if vim.fn.filereadable(runtime.host_root .. "/" .. config_file) ~= 1 then
        vim.notify(string.format("php.phpunit.setup: %s not found, skipping", config_file), vim.log.levels.WARN)
        return
    end

    vim.api.nvim_create_user_command(COMMAND_NAME, function(cmd_opts)
        local cmd = "vendor/bin/phpunit"
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

    _G.Project:register_tool({
        namespace = "php",
        name = "phpunit",
        summary = string.format(":%s command, runs in %s", COMMAND_NAME, runtime.service),
    })
end

return M
