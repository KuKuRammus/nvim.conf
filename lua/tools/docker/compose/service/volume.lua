-- tools.docker.compose.service.volume
--
-- DockerComposeVolumeMapping
-- Handles bind, volume and tmpfs types
--

--- @class DockerComposeServiceVolumeMapping A single mount for a service
---
--- @field raw table                Raw mount table
--- @field type string              "bind", "volume", or "tmpfs"
--- @field host_path string         Source: host path for bind, volume name for volume, empty for tmpfs
--- @field container_path string    Target: absolute path inside container
--- @field read_only boolean        Flag: is mount read-only
--- @field bind_propagation? string "rprivate", "shared", etc.
--- @field volume_nocopy? boolean   Disabled copy-up for named volumes
--- @field tmpfs_size? integer      tmpfs size in bytes
--- @field tmpfs_mode? integer      tmpfs permission bits
local M = {}
M.__index = M

--- Constructs a mapping
--- @param fields DockerComposeServiceVolumeMapping
--- @return DockerComposeServiceVolumeMapping
function M.new(fields)
    return setmetatable(fields, M)
end

return M
