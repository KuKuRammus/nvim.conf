-- tools.docker.compose.service.port
--
-- DockerComposeServicePortMapping
--

--- @class DockerComposeServicePortMapping
--- @field host_port? integer       Published host port (nil if random/expose-only)
--- @field container_port integer   Container port
--- @field protocol string          "tcp" (default) or "udp"
--- @field host_ip? string          Bind host IP
local M = {}
M.__index = M

--- Constructs a mapping
--- @param fields DockerComposeServicePortMapping
--- @return DockerComposeServicePortMapping
function M.new(fields)
    return setmetatable(fields, M)
end

return M
