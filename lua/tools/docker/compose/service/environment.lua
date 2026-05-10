-- tools.docker.compose.service.environment
--
-- Parses a service's environment variables into a table<string, string>
-- Compose accepts 2 forms:
--     - map: { KEY = "value", ... }
--     - array: { "KEY=value", "KEY2=value2", ... }
-- Both values are normalized to a flat string -> string map
--

local M = {}

--- Parse a service's `environment` into a table<string, string>
--- @param raw table
--- @return table<string, string>
function M.parse(raw)
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

return M
