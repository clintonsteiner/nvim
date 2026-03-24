local M = {}

local function get_lock_file(filepath)
    return filepath .. ".nvim.lock"
end

local function get_server_id()
    local servername = vim.v.servername or "nvim"
    return servername .. ":" .. vim.fn.getpid()
end

local function read_lock(lockfile)
    local f = io.open(lockfile, "r")
    if not f then
        return nil
    end
    local content = f:read("*a")
    f:close()
    return content:gsub("\n", "")
end

local function write_lock(lockfile, server_id)
    local f = io.open(lockfile, "w")
    if f then
        f:write(server_id)
        f:close()
        return true
    end
    return false
end

local function remove_lock(lockfile)
    os.remove(lockfile)
end

local function server_exists(server_name)
    local servers = vim.fn.serverlist()
    for _, server in ipairs(servers) do
        if server == server_name then
            return true
        end
    end
    return false
end

function M.set_readonly(filepath)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_name(buf) == filepath then
            vim.api.nvim_buf_set_option(buf, "readonly", true)
            vim.notify(
                "File is being edited in another Neovim instance. Switched to readonly.",
                vim.log.levels.INFO
            )
            return
        end
    end
end

function M.check_and_acquire_lock(bufnr)
    local filepath = vim.api.nvim_buf_get_name(bufnr)
    if not filepath or filepath == "" then
        return
    end

    local lockfile = get_lock_file(filepath)
    local existing_lock = read_lock(lockfile)
    local current_server = get_server_id()

    if existing_lock and existing_lock ~= current_server then
        -- Another instance has this file locked
        local other_server = existing_lock:match("^([^:]+)")

        -- Check if the other server is still running
        if other_server and server_exists(other_server) then
            -- Set current buffer to readonly
            vim.api.nvim_buf_set_option(bufnr, "readonly", true)
            vim.notify(
                string.format("File is being edited in %s. Switched to readonly.", other_server),
                vim.log.levels.WARN
            )
            return
        end
    end

    -- Acquire lock for this instance
    write_lock(lockfile, current_server)
    vim.api.nvim_buf_set_option(bufnr, "readonly", false)
end

function M.release_lock(bufnr)
    local filepath = vim.api.nvim_buf_get_name(bufnr)
    if filepath and filepath ~= "" then
        local lockfile = get_lock_file(filepath)
        local existing_lock = read_lock(lockfile)
        local current_server = get_server_id()

        -- Only remove lock if we own it
        if existing_lock == current_server then
            remove_lock(lockfile)
        end
    end
end

-- Setup autocommands
local group = vim.api.nvim_create_augroup("FileEditLock", { clear = true })

vim.api.nvim_create_autocmd("BufRead", {
    group = group,
    callback = function(args)
        M.check_and_acquire_lock(args.buf)
    end,
})

vim.api.nvim_create_autocmd("BufUnload", {
    group = group,
    callback = function(args)
        M.release_lock(args.buf)
    end,
})

vim.api.nvim_create_autocmd("VimLeave", {
    group = group,
    callback = function()
        -- Clean up all locks when exiting Neovim
        local cwd = vim.fn.getcwd()
        for fname in vim.fn.glob(cwd .. "/**/*.nvim.lock", true, true) do
            local lock_content = read_lock(fname)
            local current_server = get_server_id()
            if lock_content == current_server then
                remove_lock(fname)
            end
        end
    end,
})

return M
