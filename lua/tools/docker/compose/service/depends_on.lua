-- tools.docker.compose.service.depends_on
--
-- Parses a sevice's depends_on into a list of service names
-- Compose accepts 2 forms:
--     - array of strings
--     - map keyed by service names (with additional parameters)
-- Both are normalized to a sorted array for names for simplicity
--

local M = {}

--- Parses depends_on
--- @param raw table
--- @return string[]
function M.parse(raw)
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

return M
