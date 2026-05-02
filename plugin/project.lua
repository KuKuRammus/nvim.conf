-- Project state and management commands
-- `_G.Project` is the single namespace for project-scoped state
-- Tool modules push entries into `Project.tools` when their `setup()` runs
-- Runtime modules push entries into `Project.runtimes` when their `describe()` runs
-- Both lists are cleared on `DirChanged`
--

--- @class ProjectToolEntry
--- @field namespace string Technology namespace (e.g. "php", "docker")
--- @field name string      Tool name (e.g. "phpcs", "phpunit")
--- @field summary? string  Optional one-line description shown in :Project info

--- @class ProjectRuntimeEntry
--- @field namespace string Technology namespace (e.g. "docker")
--- @field name string      Runtime kind (e.g. "composer_service")
--- @field summary? string  Optional one-line description shown in :Project info

--- @class ProjectState
--- @field tools ProjectToolEntry[]
--- @field runtimes ProjectRuntimeEntry[]
--- @field register_runtime fun(entry: ProjectRuntimeEntry)
--- @field register_tool fun(entry: ProjectToolEntry)

--- @type ProjectState
_G.Project = _G.Project or {
    tools = {},
    runtimes = {},
}

--- Register a runtime descriptor in project state
--- @param entry ProjectRuntimeEntry
function _G.Project:register_runtime(entry)
    vim.validate({
        namespace = { entry.namespace, "string" },
        name = { entry.name, "string" },
        summary = { entry.summary, "string", true },
    })
    table.insert(self.runtimes, entry)
end

--- Register a tool in project state
--- @param entry ProjectToolEntry
function _G.Project:register_tool(entry)
    vim.validate({
        namespace = { entry.namespace, "string" },
        name = { entry.name, "string" },
        summary = { entry.summary, "string", true },
    })
    table.insert(self.tools, entry)
end

local M = {}

-- Reset all project-scoped state. Called on DirChanged or :Project reload
local function reset()
    _G.Project.tools = {}
    _G.Project.runtimes = {}
end

-- Render the current project state into a scratch buffer
local function show_info()
    local lines = {
        "Project root: " .. vim.fn.getcwd(),
        "exrc: " .. tostring(vim.o.exrc),
        "",
        string.format("Runtimes: %d", #_G.Project.runtimes),
    }

    if #_G.Project.runtimes == 0 then
        table.insert(lines, " (none)")
    else
        for _, r in ipairs(_G.Project.runtimes) do
            table.insert(lines, string.format(" [%s] %s - %s", r.namespace, r.name, r.summary or ""))
        end
    end

    table.insert(lines, "")
    table.insert(lines, string.format("Tools: %d", #_G.Project.tools))

    if #_G.Project.tools == 0 then
        table.insert(lines, " (no - no .nvim.lua, or no setup() calls succeeded)")
    else
        for _, t in ipairs(_G.Project.tools) do
            table.insert(lines, string.format(" [%s] %s - %s", t.namespace, t.name, t.summary or ""))
        end
    end

    vim.cmd("botright new")
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].filetype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].modifiable = false
    vim.api.nvim_buf_set_name(buf, "[Project]")
    vim.api.nvim_win_set_height(0, math.min(#lines + 2, 25))
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true })
end

-- Re-sources `.nvim.lua` from the current working directory
-- Clears existing state first to avoid duplicates
local function reload()
    reset()

    local rc = vim.fn.getcwd() .. "/.nvim.lua"
    if vim.fn.filereadable(rc) ~= 1 then
        vim.notify("No .nvim.lua in " .. vim.fn.getcwd(), vim.log.levels.WARN)
        return
    end

    local ok, err = pcall(dofile, rc)
    if not ok then
        vim.notify("Project reload failed: " .. tostring(err), vim.log.levels.ERROR)
        return
    end

    vim.notify("Project reloaded", vim.log.levels.INFO)
end

-- Subcommands. Keys are subcommand names, values are zero-arg functions
--- @type table<string, fun()>
local subcommands = {
    info = show_info,
    reload = reload,
}

-- :Project <subcommand> handler
vim.api.nvim_create_user_command("Project", function(opts)
    local sub = opts.fargs[1]

    -- No subcommand specified - default to showing project info
    if not sub or sub == "" then
        show_info()
        return
    end

    local handler = subcommands[sub]
    if not handler then
        vim.notify("Unknown :Project subcommand: " .. sub, vim.log.levels.ERROR)
        return
    end

    handler()
end, {
    nargs = "?",
    complete = function(arg_lead)
        local matches = {}
        for name in pairs(subcommands) do
            if name:sub(1, #arg_lead) == arg_lead then
                table.insert(matches, name)
            end
        end

        return matches
    end,
    desc = "Project management: info (default), reload",
})

-- Trigger project reset on cwd change
vim.api.nvim_create_autocmd("DirChanged", {
    group = vim.api.nvim_create_augroup("project-reset", { clear = true }),
    callback = reset,
})

return M
