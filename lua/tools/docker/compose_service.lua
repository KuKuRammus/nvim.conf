-- tools.docker.compose_service
--
-- Pure descriptor for one specific service in a docker-compose project
-- No editor side effects
-- Returns a value, which can be used by other tools during setup() calls
--

--- @class ComposerServiceOpts
--- @field service string           Service name as desclared in docker-compose file
--- @field container_root string    Absolute path inside container where project is mounted
--- @field host_root? string        Absolute project root on host. Auto-detected from compose file location if ommited
--- @field compose_file? string     Path to compose file. If ommited, walks upward from host_root or cwd

local M = {}

local DEFAULT_COMPOSE_FILE_NAMES = {
    "docker-compose.yaml",
    "docker-compose.yml",
    "compose.yml",
}

--- Walks upward from `start_dir` looking for the first matching compose file
--- @param start_dir string
--- @param candidates string[]
--- @return string|nil Absolute path or nil if none found
local function find_compose_file(start_dir, candidates)
    return vim.fs.find(candidates, {
        upward = true,
        path = start_dir,
        stop = vim.uv.os_homedir(),
    })[1]
end

--- Construct a compose-service descriptor
--- @param opts ComposerServiceOpts
--- @return ComposerServiceDescriptor
function M.describe(opts)
    opts = opts or {}

    vim.validate({
        service = { opts.service, "string" },
        container_root = { opts.container_root, "string" },
        host_root = { opts.host_root, "string", true },
        compose_file = { opts.compose_file, "string", true },
    })

    -- Ensure container_root start with "/"
    if opts.container_root:sub(1, 1) ~= "/" then
        error(string.format("compose_service.describe: container_root %q must be absolute", opts.container_root), 2)
    end

    -- Resolve compose_file and host_root
    -- Priority: explicit compose_file -> Auto-detect from host_root or cwd
    local host_root = opts.host_root
    local compose_path

    if opts.compose_file then
        compose_path = vim.fn.fnamemodify(opts.compose_file, ":p")
        if vim.fn.filereadable(compose_path) ~= 1 then
            error(string.format("compose_service.describe: compose_file %q is not readable", compose_path), 2)
        end

        if not host_root then
            host_root = vim.fs.dirname(compose_path)
        end
    else
        local start = host_root or vim.fn.getcwd()
        compose_path = find_compose_file(start, DEFAULT_COMPOSE_FILE_NAMES)
        if not compose_path then
            error(string.format("compose_service.describe: no docker compose file found upward from %q", start), 2)
        end

        if not host_root then
            host_root = vim.fs.dirname(compose_path)
        end
    end

    --- @class ComposerServiceDescriptor
    --- @field service string
    --- @field host_root string
    --- @field container_root string
    --- @field compose_file string      Absolute path to the resolved compose file
    local descriptor = {
        service = opts.service,
        host_root = host_root,
        container_root = opts.container_root,
        compose_file = compose_path,
    }

    --- Translates a host absolute path to its container counterpart
    --- If the path is not under host_root, returns it unchanged
    --- @param host_path string
    --- @return string
    function descriptor:to_container_path(host_path)
        if not host_path or host_path == "" then
            return host_path
        end

        if host_path:sub(1, #self.host_root) == self.host_root then
            return self.container_root .. host_path:sub(#self.host_root + 1)
        end

        return host_path
    end

    --- Translates container path (absolute or relative to project root) to host path
    --- @param container_path string
    --- @return string
    function descriptor:to_host_path(container_path)
        if not container_path or container_path == "" then
            return container_path
        end

        -- Relative path
        if container_path:sub(1, 1) ~= "/" then
            return self.host_root .. "/" .. container_path
        end

        -- Absolute path
        if container_path:sub(1, #self.container_root) == self.container_root then
            return self.host_root .. container_path:sub(#self.container_root + 1)
        end

        return container_path
    end

    --- Build the docker compose exec invocation as a list, ready for vim.system
    --- @param cmd_array string[]
    --- @return string[]
    function descriptor:build_exec_args(cmd_array)
        local args = { "docker", "compose", "exec", "-T", self.service }
        for _, a in ipairs(cmd_array) do
            table.insert(args, a)
        end

        return args
    end

    --- Exec something async. Callback runs on the main thread with vim.system result
    --- @param cmd_array string[]
    --- @param callback fun(result: vim.SystemCompleted)
    function descriptor:exec_async(cmd_array, callback)
        local cmd = self:build_exec_args(cmd_array)
        vim.system(cmd, { cwd = self.host_root, text = true }, function(result)
            vim.schedule(function()
                callback(result)
            end)
        end)
    end

    --- Exec something in a terminal split, running `cmd_string` inside a service
    --- Uses interactive exec (no -T) so progress UIs and colors render
    --- @param cmd_string string
    function descriptor:exec_terminal(cmd_string)
        vim.cmd(
            string.format(
                "botright split | resize 15 | terminal docker compose exec %s %s",
                vim.fn.shellescape(self.service),
                cmd_string
            )
        )
    end

    -- Register
    if _G.Project then
        _G.Project:register_runtime({
            namespace = "docker",
            name = "compose_service",
            summary = string.format(
                "service=%s, container_root=%s, host_root=%s",
                descriptor.service,
                descriptor.container_root,
                descriptor.host_root
            ),
        })
    end

    return descriptor
end

return M
