-- tools.php.phpstan
--
-- Registers :Phpstan [path] user command. Runs phpstan async in container,
-- parses JSON output, populates quickfix
--

--- @class PhpstanSetupOpts
--- @field runtime ComposeServiceDescriptor
--- @field config_file? string      Config file name (default: phpstan.neon)
--- @field memory_limit? string     Memory limit (default: "1G")
--- @field bin_path? string         Path to phpstan bin (default: vendor/bin/phpstan)
--- @field user_cmd_name? string    Vim user command name (default: :Phpstan)

local shared = require("tools._shared")

local M = {}

local DEFAULT_CONFIG_FILE = "phpstan.neon"
local DEFAULT_MEMORY_LIMIT = "1G"
local DEFAULT_BIN_PATH = "vendor/bin/phpstan"
local DEFAULT_USER_COMMAND_NAME = "Phpstan"

--- @param opts PhpstanSetupOpts
function M.setup(opts)
    vim.validate({
        runtime = { opts.runtime, "table" },
        config_file = { opts.config_file, "string", true },
        memory_limit = { opts.memory_limit, "string", true },
        bin_path = { opts.bin_path, "string", true },
        user_cmd_name = { opts.user_cmd_name, "string", true },
    })

    local config_file = opts.config_file or DEFAULT_CONFIG_FILE
    local memory_limit = opts.memory_limit or DEFAULT_MEMORY_LIMIT
    local bin_path = opts.bin_path or DEFAULT_BIN_PATH
    local user_cmd_name = opts.user_cmd_name or DEFAULT_USER_COMMAND_NAME
    local runtime = opts.runtime

    -- Validate config file present
    if vim.fn.filereadable(runtime.host_root .. "/" .. config_file) ~= 1 then
        vim.notify(string.format("php.phpstan.setup: %s not found, skipping", config_file), vim.log.levels.WARN)
        return
    end

    vim.api.nvim_create_user_command(user_cmd_name, function(cmd_opts)
        local args = {
            bin_path,
            "analyse",
            "--error-format=json",
            "--no-progress",
            "--no-interaction",
            "--memory-limit=" .. memory_limit,
            "--configuration=" .. config_file,
        }
        if cmd_opts.args ~= "" then
            table.insert(args, runtime:to_container_path(vim.fn.fnamemodify(cmd_opts.args, ":p")))
        end

        vim.notify("Running phpstan...", vim.log.levels.INFO)
        runtime:exec_async(args, function(result)
            local decoded = shared.decode_json(result.stdout)
            if not decoded then
                vim.notify("phpstan: failed to parse output: stderr: " .. (result.stderr or ""), vim.log.levels.ERROR)
                return
            end

            local items = {}
            for file, file_data in pairs(decoded.files or {}) do
                local host_path = runtime:to_host_path(file)
                for _, msg in ipairs(file_data.messages or {}) do
                    table.insert(items, {
                        filename = host_path,
                        lnum = msg.line or 1,
                        col = 1,
                        text = msg.message or "",
                        type = "E",
                    })
                end
            end

            for _, msg in ipairs(decoded.errors or {}) do
                table.insert(items, {
                    filename = "",
                    lnum = 0,
                    col = 0,
                    text = msg,
                    type = "E",
                })
            end

            shared.set_quickfix("phpstan", items)
        end)
    end, {
        nargs = "?",
        complete = "file",
        desc = "Run PHPStan (optionally scoped to a path)",
    })

    _G.Project:register_tool({
        namespace = "php",
        name = "phpstan",
        summary = string.format(":%s command, runs in %s", user_cmd_name, runtime.service),
    })
end

return M
