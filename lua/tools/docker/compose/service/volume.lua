-- tools.docker.compose.service.volume
--
-- Parses a sevice's volume entries into DockerComposeVolumeMapping[]
-- Handles bind, volume and tmpfs types
--

--- @class DockerComposeServiceVolumeMapping A single mount for a service
---
--- @field type string              "bind", "volume", or "tmpfs"
--- @field host_path string         Source: host path for bind, volume name for volume, empty for tmpfs
--- @field container_path string    Target: absolute path inside container
--- @field read_only boolean        Flag: is mount read-only
--- @field bind_propagation? string "rprivate", "shared", etc.
--- @field volume_nocopy? boolean   Disabled copy-up for named volumes
--- @field tmpfs_size? integer      tmpfs size in bytes
--- @field tmpfs_mode? integer      tmpfs permission bits
--- @field raw table                Raw mount table

local M = {}

--- Parses a single record from `volumes` array
--- @param raw table Raw table of the single volumes item
--- @return DockerComposeServiceVolumeMapping|nil
function M.parse(raw)
    if type(raw) ~= "table" or not raw.target then
        return nil
    end

    --- @type DockerComposeServiceVolumeMapping
    local mapping = {
        type = raw.type or "bind",
        host_path = raw.source or "",
        container_path = raw.target,
        read_only = raw.read_only or false,
        raw = raw,
    }

    -- .bind
    if raw.bind then
        mapping.bind_propagation = raw.bind.propagation
    end

    -- .volume
    if raw.volume then
        mapping.volume_nocopy = raw.volume.nocopy
    end

    -- .tmpfs
    if raw.tmpfs then
        mapping.tmpfs_size = raw.tmpfs.size
        mapping.tmpfs_mode = raw.tmpfs.mode
    end

    return mapping
end

return M
