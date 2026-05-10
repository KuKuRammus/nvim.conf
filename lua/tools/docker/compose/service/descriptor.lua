-- tools.docker.compose.service.descriptor
--
-- DockerComposeServiceDesciptor
--

--- @class DockerComposeServiceDesciptor
--- @field raw table
--- @field name string
---
--- Project context
--- @field host_root string
--- @field container_root? string
--- @field docker_compose? DockerComposeDescriptor
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
--- Env
--- @field environment table<string, string>
--- @field env_file? string|string[]
---
--- Networking
--- @field ports DockerComposeServicePortMapping[]
--- @field expose? string[]
--- @field networks? string[]
--- @field hostname? string
--- @field extra_hosts? string[]
---
--- Storage
--- @field volumes DockerComposeServiceVolumeMapping[]
--- @field tmpfs? string|string[]
---
--- Lifecycle
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

local M = {}
M.__index = M

--- Constructs a descriptor
--- @param fields DockerComposeServiceDesciptor
--- @return DockerComposeServiceDesciptor
function M.new(fields)
    return setmetatable(fields, M)
end

--- Translate a host absolute path to its container counterpart.
--- Returns input unchanged if container_root is unset or path is outside host_root.
--- @param host_path string
--- @return string
function M:to_container_path(host_path)
    if not host_path or host_path == "" or not self.container_root then
        return host_path
    end
    if host_path:sub(1, #self.host_root) == self.host_root then
        return self.container_root .. host_path:sub(#self.host_root + 1)
    end
    return host_path
end

--- Translate a container path to its host counterpart.
--- Handles relative paths (treated as relative to project root) and absolute
--- paths under container_root.
--- @param container_path string
--- @return string
function M:to_host_path(container_path)
    if not container_path or container_path == "" then
        return container_path
    end
    if container_path:sub(1, 1) ~= "/" then
        return self.host_root .. "/" .. container_path
    end
    if self.container_root and container_path:sub(1, #self.container_root) == self.container_root then
        return self.host_root .. container_path:sub(#self.container_root + 1)
    end
    return container_path
end

--- Build the docker compose exec invocation as a list, ready for vim.system.
--- @param cmd_array string[]
--- @return string[]
function M:build_exec_args(cmd_array)
    local args = { "docker", "compose", "exec", "-T", self.name }
    for _, a in ipairs(cmd_array) do
        table.insert(args, a)
    end
    return args
end

--- Same as build_exec_args but without the leading "docker" element.
--- Useful for conform.nvim / nvim-lint which separate command from args.
--- @param cmd_array string[]
--- @return string[]
function M:build_exec_args_only(cmd_array)
    return vim.list_slice(self:build_exec_args(cmd_array), 2)
end

--- Async exec inside the service. Callback runs on the main thread.
--- @param cmd_array string[]
--- @param callback fun(result: vim.SystemCompleted)
function M:exec_async(cmd_array, callback)
    local cmd = self:build_exec_args(cmd_array)
    vim.system(cmd, { cwd = self.host_root, text = true }, function(result)
        vim.schedule(function()
            callback(result)
        end)
    end)
end

--- Open a terminal split running cmd_string inside the service.
--- Uses interactive exec so colored output and progress UIs render.
--- @param cmd_string string
function M:exec_terminal(cmd_string)
    vim.cmd(
        string.format(
            "botright split | resize 15 | terminal docker compose exec %s %s",
            vim.fn.shellescape(self.name),
            cmd_string
        )
    )
end

return M
