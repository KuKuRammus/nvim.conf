-- tools._shared
--
-- Utilities, shared across tools/* integrations.
-- Not intended for require from outside of the tools tree
--

local M = {}

--- Populate the quickfix list from a list of items, open if non-empty
--- Items must use the standard Vim quickfix item shape:
---     { filename, lnum, col, text, type }
--- @param title string
--- @param items table[]
function M.set_quickfix(title, items)
    vim.fn.setqflist({}, "r", { title = title, items = items })
    if #items > 0 then
        vim.cmd("copen")
        vim.notify(string.format("%s: %d issues", title, #items), vim.log.levels.WARN)
    else
        vim.cmd("cclose")
        vim.notify(title .. ": clean", vim.log.levels.INFO)
    end
end

--- Decode JSON blob safely
--- @param raw string|nil
--- @return table|nil
function M.decode_json(raw)
    if raw == nil or raw == "" then
        return nil
    end

    local ok, decoded = pcall(vim.json.decode, raw)
    if not ok or type(decoded) ~= "table" then
        return nil
    end

    return decoded
end

return M
