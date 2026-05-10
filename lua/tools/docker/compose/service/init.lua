-- tools.docker.compose.service
--
-- Parses a service definition
--

local Descriptor = require("tools.docker.compose.service.descriptor")
local ServicePortMapping = require("tools.docker.compose.service.port")
local ServiceVolumeMapping = require("tools.docker.compose.service.volume")

local M = {}

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

--- Parse a service's `environment` into a table<string, string>
--- Compose accepts 2 forms:
---     - map: { KEY = "value", ... }
---     - array: { "KEY=value", "KEY2=value2", ... }
--- Both values are normalized to a flat string -> string map
--- @param raw table|nil
--- @return table<string, string>
local function parse_environment(raw)
    local env = {}
    if type(raw) ~= "table" then
        return env
    end

    -- Map form
    if not vim.islist(raw) then
        for key, value in pairs(raw) do
            env[key] = tostring(value)
        end

        return env
    end

    -- Array form
    for _, entry in ipairs(raw) do
        if type(entry) == "string" then
            local eq = entry:find("=")

            if eq then
                env[entry:sub(1, eq - 1)] = entry:sub(eq + 1)
            else
                env[entry] = ""
            end
        end
    end

    return env
end

--- Parses ports
--- @param raw table|nil
--- @return DockerComposeServicePortMapping[]
local function parse_ports(raw)
    local mappings = {}
    if type(raw) ~= "table" then
        return mappings
    end

    for _, raw_port in ipairs(raw) do
        if type(raw_port) == "table" and raw_port.target then
            table.insert(
                mappings,
                ServicePortMapping.new({
                    host_port = raw_port.published and tonumber(raw_port.published, 10) or nil,
                    container_port = tonumber(raw_port.published, 10),
                    protocol = raw_port.protocol or "tcp",
                    host_ip = raw_port.host_ip,
                })
            )
        end
    end

    return mappings
end

--- Parses list of volume mappings
--- @param raw table[]|nil
--- @return DockerComposeServiceVolumeMapping[]
local function parse_volumes(raw)
    local mappings = {}
    if type(raw) ~= "table" then
        return mappings
    end

    for _, raw_volume in ipairs(raw) do
        if type(raw_volume) == "table" and raw_volume.target then
            local vol = ServiceVolumeMapping.new({
                raw = raw_volume,
                type = raw_volume.type or "bind",
                host_path = raw_volume.source or "",
                container_path = raw_volume.target,
                read_only = raw_volume.read_only or false,
            })

            -- .bind
            if raw_volume.bind then
                vol.bind_propagation = raw_volume.bind.propagation
            end

            -- .volume
            if raw_volume.volume then
                vol.volume_nocopy = raw_volume.volume.nocopy
            end

            -- .tmpfs
            if raw_volume.tmpfs then
                vol.tmpfs_size = raw_volume.tmpfs.size
                vol.tmpfs_mode = raw_volume.tmpfs.mode
            end

            table.insert(mappings, vol)
        end
    end

    return mappings
end

--- Parses depends_on
--- @param raw table|nil
--- @return string[]
local function parse_depends_on(raw)
    local deps = {}
    if type(raw) ~= "table" then
        return deps
    end

    if vim.islist(raw) then
        for _, name in ipairs(raw) do
            if type(name) == "string" then
                table.insert(deps, name)
            end
        end
    else
        for name in pairs(raw) do
            table.insert(deps, name)
        end
    end

    table.sort(deps)

    return deps
end

--- Parses service item
--- @param name string
--- @param raw table
--- @param host_root string
--- @return DockerComposeServiceDesciptor
function M.parse(name, raw, host_root)
    local environment = parse_environment(raw.environment)
    local ports = parse_ports(raw.ports)
    local volumes = parse_volumes(raw.volumes)
    local depends_on = parse_depends_on(raw.depends_on)

    return Descriptor.new({
        -- Identity / Project context
        raw = raw,
        name = name,
        host_root = host_root,
        container_root = derive_container_root(volumes, host_root),

        -- Late bound
        docker_compose = nil,

        -- Image / build
        image = raw.image,
        build = raw.build,

        -- Process
        command = raw.command,
        entrypoint = raw.entrypoint,
        working_dir = raw.working_dir,
        user = raw.user,
        tty = raw.tty,
        stdin_open = raw.stdin_open,

        -- Environment
        environment = environment,
        env_file = raw.env_file,

        -- Networking
        ports = ports,
        expose = raw.expose,
        networks = raw.networks,
        hostname = raw.hostname,
        extra_hosts = raw.extra_hosts,

        -- Storage
        volumes = volumes,
        tmpfs = raw.tmpfs,

        -- Lifecycle
        depends_on = depends_on,
        healthcheck = raw.healthcheck,
        restart = raw.restart,

        -- Resources
        deploy = raw.deploy,
        mem_limit = raw.mem_limit,
        cpus = raw.cpus,

        -- Misc
        profiles = raw.profiles,
        labels = raw.labels,
        container_name = raw.container_name,
        privileged = raw.privileged,
    })
end

return M
