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

local Descriptor = require("tools.docker.compose.descriptor")

local M = {}

local DEFAULT_COMPOSE_FILE_NAMES = {
    "docker-compose.yaml",
    "docker-compose.yml",
    "compose.yaml",
    "compose.yml",
}

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

--- Builds a DockerComposeDescriptor
--- @param opts DockerComposeDescribeOpts
--- @return DockerComposeDescriptor
function M.describe(opts)
    opts = opts or {}
    vim.validate({
        compose_file = { opts.compose_file, "string", true },
        host_root = { opts.host_root, "string", true },
    })

    -- Resolve paths
    local compose_path

    if opts.compose_file then
        compose_path = vim.fn.fnamemodify(opts.compose_file, ":p")
        if vim.fn.filereadable(compose_path) ~= 1 then
            error(string.format("docker compose file %q is not readable", compose_path), 3)
        end
    else
        local start = opts.host_root or vim.fn.getcwd()
        compose_path = vim.fs.find(DEFAULT_COMPOSE_FILE_NAMES, {
            upward = true,
            path = start,
            stop = vim.uv.os_homedir(),
        })[1]
        if not compose_path then
            error(string.format("no docker compose file found upward from %q", start), 3)
        end
    end

    local host_root = opts.host_root or vim.fs.dirname(compose_path)

    -- Parse file
    local raw = load_compose_config(compose_path, host_root)

    -- Additional data
    local project_name = raw.name or vim.fs.basename(host_root)

    -- Parse every service
    local services = {}
    for name, raw_service in pairs(raw.services or {}) do
        services[name] = service.parse(name, raw_service, host_root)
    end

    local descriptor = Descriptor.new({
        raw = raw,
        compose_file = compose_path,
        host_root = host_root,
        project_name = project_name,
        services = services,
        networks = raw.networks or {},
        volumes = raw.volumes or {},
    })

    -- Attach created docker compose descriptor to services
    for _, svc in pairs(services) do
        svc.docker_compose = descriptor
    end

    if _G.Project then
        _G.Project:register_runtime({
            namespace = "docker",
            name = "compose",
            summary = string.format(
                "compose_file=%s, services=[%s]",
                compose_path,
                table.concat(descriptor:service_name_list(), ", ")
            ),
        })
    end

    return descriptor
end

return M
