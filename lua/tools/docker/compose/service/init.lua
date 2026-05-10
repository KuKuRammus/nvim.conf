-- tools.docker.compose.service
--
-- Parses a service definition
--

--- @class DockerComposeService
---
--- @field raw table Raw service subtree
--- @field name string Service key in compose file
---
--- Image / build
--- @field image? string
--- @field build? table
---
--- Process
--- @field command? string|string[]
--- @field entrypoint? string|string[]
--- @field working_dir? string
--- @field user? string
--- @field tty? boolean
--- @field stdin_open? boolean
---
--- Environment / configuration
--- @field environment table<string, string>
--- @field env_file? string|string[]
---
--- Networking
--- @field ports DockerComposeServicePortMapping[]
--- @field expose? string[]
--- @field networks? string[]|table
--- @field hostname? string
--- @field extra_hosts? string[]
---
--- Storage
--- @field volumes DockerComposeServiceVolumeMapping[]
--- @field tmpfs? string|string[]
---
--- Lifecycle / health
--- @field depends_on string[]
--- @field healthcheck? table
--- @field restart? string
---
--- Resources
--- @field deploy? table
--- @field mem_limit? string|integer
--- @field cpus? number
---
--- Misc
--- @field profiles? string[]
--- @field labels? table<string, string>
--- @field container_name? string
--- @field privileged? boolean

local volume = require("tools.docker.compose.service.volume")
local port = require("tools.docker.compose.service.port")
local environment = require("tools.docker.compose.service.environment")
local depends_on = require("tools.docker.compose.service.depends_on")

local M = {}

--- Parses service item
--- @param name string
--- @param raw table
--- @return DockerComposeService
function M.parse(name, raw)
    local envs = environment.parse(raw.environment or {})

    local ports = {}
    if type(raw.ports) == "table" then
        for _, raw_port in ipairs(raw.ports) do
            local parsed_port = port.parse(raw_port)
            if parsed_port then
                table.insert(ports, parsed_port)
            end
        end
    end

    local volumes = {}
    if type(raw.volumes) == "table" then
        for _, raw_volume in ipairs(raw.volumes) do
            local parsed_volume = volume.parse(raw_volume)
            if parsed_volume then
                table.insert(volumes, parsed_volume)
            end
        end
    end

    local depends = depends_on.parse(raw.depends_on or {})

    --- @type DockerComposeService
    local service = {
        name = name,
        raw = raw,

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
        environment = envs,
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
        depends_on = depends,
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
    }

    return service
end

return M
