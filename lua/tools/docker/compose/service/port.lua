-- tools.docker.compose.service.port
--
-- Parses a service's poer mappings into a DockerComposeServicePortMapping
--

--- @class DockerComposeServicePortMapping
--- @field host_port? integer       Published host port (nil if random/expose-only)
--- @field container_port integer   Container port
--- @field protocol string          "tcp" (default) or "udp"
--- @field host_ip? string          Bind host IP

local M = {}

--- Parse a single item from service's `ports` item
--- @param raw table
--- @return DockerComposeServicePortMapping|nil
function M.parse(raw)
    if type(raw) ~= "table" or not raw.target then
        return nil
    end

    --- @type DockerComposeServicePortMapping
    local mapping = {
        host_port = raw.published and tonumber(raw.published, 10) or nil,
        container_port = tonumber(raw.target, 10),
        protocol = raw.protocol or "tcp",
        host_ip = raw.host_ip,
    }

    return mapping
end

return M
