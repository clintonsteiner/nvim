local M = {}

local function get_git_root()
    local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
    if vim.v.shell_error == 0 then
        return git_root
    end
    return nil
end

local function sanitize_name(name)
    return name:gsub("[^a-zA-Z0-9_-]", "_")
end

function M.start_session()
    vim.ui.input({ prompt = "Session name: " }, function(name)
        if not name or name == "" then
            vim.notify("Session name cannot be empty", vim.log.levels.WARN)
            return
        end

        local git_root = get_git_root()
        if not git_root then
            vim.notify("Not in a git repository", vim.log.levels.ERROR)
            return
        end

        local safe_name = sanitize_name(name)
        local branch = "claude/" .. safe_name
        local worktree_dir = git_root .. "/.worktrees/" .. safe_name

        -- Create git worktree
        local cmd = string.format("git worktree add %s -b %s", vim.fn.shellescape(worktree_dir), vim.fn.shellescape(branch))
        local result = vim.fn.system(cmd)
        if vim.v.shell_error ~= 0 then
            vim.notify("Failed to create worktree: " .. result, vim.log.levels.ERROR)
            return
        end

        -- Open FTerm scratch terminal with claude command
        require("FTerm").scratch({
            cmd = { "claude" },
            cwd = worktree_dir,
            hl = "Normal,FloatBorder:FzfLuaBorder",
            border = "rounded",
        })

        vim.notify("Claude session started in " .. worktree_dir, vim.log.levels.INFO)
    end)
end

function M.stop_session()
    require("FTerm").close()
    vim.notify("Claude session stopped", vim.log.levels.INFO)
end

function M.toggle_session()
    require("FTerm").toggle()
end

return M
