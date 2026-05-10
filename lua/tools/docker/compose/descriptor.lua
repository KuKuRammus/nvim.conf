-- tools.docker.compose.descriptor
--
-- DockerComposeDescriptor
--

--- @class DockerComposeDescriptor
--- @field raw table                                                Full parsed compose file
--- @field compose_file string                                      Absolute path to the compose file
--- @field host_root string                                         Absolute project root on host
--- @field project_name string                                      Compose project name
--- @field services table<string, DockerComposeServiceDesciptor>    Service descriptors, keyed by name
--- @field networks table<string, table>                            Raw network configs (not parsed)
--- @field volumes table<string, table>                             Raw top-level named volumes (not parsed)
local M = {}
M.__index = M

--- Construct a descriptor
--- @param fields DockerComposeDescriptor
--- @return DockerComposeDescriptor
function M.new(fields)
    return setmetatable(fields, M)
end

--- Sorted list of service names
--- @return string[]
function M:service_name_list()
    local names = {}
    for name in pairs(self.services) do
        table.insert(names, name)
    end

    table.sort(names)

    return names
end

--- Checks if provided service is present
--- @param name string
--- @return boolean
function M:has_service(name)
    return self.services[name] ~= nil
end

--- Get a service descriptor by name
--- @param name string
--- @return DockerComposeServiceDesciptor
function M:service(name)
    if not self:has_service(name) then
        error(string.format("unknown service %q. available: %s", name, table.concat(self:service_name_list(), ",")), 2)
    end

    return self.services[name]
end

return M
