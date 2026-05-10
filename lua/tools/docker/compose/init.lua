-- tools.docker.compose
--
-- Parses a docker-compose file using `docker compose config --format json`
-- and exposes services as runtime descriptors consumable by tools
--

--- @class DockerComposeDescribeOpts
--- @field compose_file? string     Path to compose file. If ommited, walks upward to find
--- @field host_root? string        Project root on host. Defaults to compose file's directory

local shared = require("tools._shared")
local service = require("tools.docker.compose.service")

local M = {}

local DEFAULT_COMPOSE_FILE_NAMES = {
    "docker-compose.yaml",
    "docker-compose.yml",
    "compose.yaml",
    "compose.yml",
}

--- Walks upward from `start_dir` looking for the first matching compose file
--- @param start_dir string
--- @param candidates string[]
--- @return string|nil
local function find_compose_file(start_dir, candidates)
    return vim.fs.find(candidates, {
        upward = true,
        path = start_dir,
        stop = vim.uv.os_homedir(),
    })[1]
end

--- Runs and parses output of `docker compose config --format json`
--- Hard-errors on failure
--- @param compose_path string
--- @param host_root string
--- @return table
local function load_compose_config(compose_path, host_root)
    local result = vim.system(
        { "docker", "compose", "-f", compose_path, "config", "--format", "json" },
        { cwd = host_root, text = true }
    ):wait()

    if result.code ~= 0 then
        error(
            string.format("`docker compose config` failed (exit %d)\nstderr: %s", result.code, result.stderr or ""),
            3
        )
    end

    if not result.stdout or result.stdout == "" then
        error("`docker compose config` produced no output", 3)
    end

    local decoded = shared.decode_json(result.stdout)
    if decoded == nil or type(decoded) ~= "table" then
        error(string.format("failed to parse compose config JSON\noutput: %s", result.stdout:sub(1, 500)), 3)
    end

    return decoded
end

--- Find the bind mount point whose host_path equals host_root
--- @param mappings DockerComposeServiceVolumeMapping[]
--- @param host_root string
--- @return string|nil
local function derive_container_root(mappings, host_root)
    for _, m in ipairs(mappings) do
        if m.type == "bind" and m.host_path == host_root then
            return m.container_path
        end
    end

    return nil
end

--- Construct a docker compose descriptor
--- @param opts DockerComposeDescribeOpts
--- @return DockerComposeDescriptor
function M.describe(opts)
    opts = opts or {}

    vim.validate({
        compose_file = { opts.compose_file, "string", true },
        host_root = { opts.host_root, "string", true },
    })

    -- Resolve compose_file and host_root
    local host_root = opts.host_root
    local compose_path

    if opts.compose_file then
        compose_path = vim.fn.fnamemodify(opts.compose_file, ":p")
        if vim.fn.filereadable(compose_path) ~= 1 then
            error(string.format("compose_file %q is not readable", compose_path), 2)
        end
    else
        local start = host_root or vim.fn.getcwd()
        compose_path = find_compose_file(start, DEFAULT_COMPOSE_FILE_NAMES)
        if not compose_path then
            error(string.format("no docker compose file found upward from %q", start), 2)
        end
    end

    if not host_root then
        host_root = vim.fs.dirname(compose_path)
    end

    -- Parse compose file
    local raw = load_compose_config(compose_path, host_root)

    -- Parse services
    local services = {}
    for name, raw_service in pairs(raw.services or {}) do
        services[name] = service.parse(name, raw_service)
    end

    --- @class DockerComposeDescriptor
    --- @field raw table
    --- @field compose_file string
    --- @field host_root string
    --- @field project_name string
    --- @field services table<string, DockerComposeService>
    --- @field networks table<string, table>
    --- @field volumes table<string, table>
    local descriptor = {
        raw = raw,
        compose_file = compose_path,
        host_root = host_root,
        project_name = raw.name or vim.fs.basename(host_root),
        services = services,
        networks = raw.networks or {},
        volumes = raw.volumes or {},
    }

    --- Get list of service names, ordered by name
    --- @return string[]
    function descriptor:list_services()
        local names = {}
        for name in pairs(self.services) do
            table.insert(names, name)
        end

        table.sort(names)
        return names
    end

    --- Returns flag if provided service exists
    --- @param name string
    --- @return boolean
    function descriptor:has_service(name)
        return self.services[name] ~= nil
    end

    --- Get the parsed DockerComposeService for `name`. Hard-errors if unknown.
    --- @param name string
    --- @return DockerComposeService
    function descriptor:get_service(name)
        if not self:has_service(name) then
            error(
                string.format(
                    "compose:get_service: unknown service %q. Available: %s",
                    name,
                    table.concat(self:list_services(), ", ")
                ),
                2
            )
        end
        return self.services[name]
    end

    --- Retrieves specific service descriptor
    --- @param name string
    --- @param overrides? { container_root?: string }
    --- @return DockerComposeService
    function descriptor:service(name, overrides)
        -- Ensure service exists
        if not self:has_service(name) then
            error(
                string.format("service not found %q, available: %s", name, table.concat(self:list_services(), ", ")),
                2
            )
        end

        local compose_service = self.services[name]

        overrides = overrides or {}

        local container_root = overrides.container_root
        if not container_root then
            container_root = derive_container_root(compose_service.volumes, self.host_root)
        end

        if not container_root then
            local mount_lines = {}
            for _, m in ipairs(compose_service.volumes) do
                if m.type == "bind" then
                    table.insert(mount_lines, string.format("    %s -> %s", m.host_path, m.container_path))
                end
            end

            local detail = "\nbind mounts:\n" .. table.concat(mount_lines, "\n")
            error(
                string.format(
                    "cannot derive container_root for service %q "
                        .. "(no bind mounts of %q). "
                        .. "Pass overrides = { container_root = ... }.%s",
                    name,
                    self.host_root,
                    detail
                ),
                2
            )
        end

        if container_root:sub(1, 1) ~= "/" then
            error(string.format("container_root %q must be absolute", container_root), 2)
        end

        --- @class DockerComposeServiceDesciptor: DockerComposeService
        --- @field host_root string
        --- @field container_root string
        --- @field docker_compose DockerComposeDescriptor
        local service_descriptor = {
            host_root = self.host_root,
            container_root = container_root,
            docker_compose = self,
        }

        --- Translates a host absolute path to its container counterpart
        --- If the path is not under host_root, returns it unchanged
        --- @param host_path string
        --- @return string
        function service_descriptor:to_container_path(host_path)
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
        function service_descriptor:to_host_path(container_path)
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
        function service_descriptor:build_exec_args(cmd_array)
            local args = { "docker", "compose", "exec", "-T", self.name }
            for _, a in ipairs(cmd_array) do
                table.insert(args, a)
            end

            return args
        end

        --- Exec something async. Callback runs on the main thread with vim.system result
        --- @param cmd_array string[]
        --- @param callback fun(result: vim.SystemCompleted)
        function service_descriptor:exec_async(cmd_array, callback)
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
        function service_descriptor:exec_terminal(cmd_string)
            vim.cmd(
                string.format(
                    "botright split | resize 15 | terminal docker compose exec %s %s",
                    vim.fn.shellescape(self.name),
                    cmd_string
                )
            )
        end

        return service_descriptor
    end

    -- Register in project state
    if _G.Project then
        _G.Project:register_runtime({
            namespace = "docker",
            name = "compose",
            summary = string.format(
                "compose_file=%s, service=[%s]",
                descriptor.compose_file,
                table.concat(descriptor:list_services(), ", ")
            ),
        })
    end

    return descriptor
end

return M
