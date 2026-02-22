---@class GoUtils
---Go development utilities for Neovim
local M = {}

local function open_go_term(cmd)
    require("FTerm").scratch({
        cmd = cmd,
        hl = "Normal,FloatBorder:FzfLuaBorder",
        border = "rounded",
    })
end

local function split_args(raw_args)
    if raw_args == nil then
        return {}
    end

    local trimmed = vim.trim(raw_args)
    if trimmed == "" then
        return {}
    end

    return vim.split(trimmed, "%s+", { trimempty = true })
end

---Run `go run` with interactive args input
---@return nil
function M.run_interactive()
    vim.ui.input({ prompt = "go run args: ", default = "." }, function(input)
        if input == nil then
            return
        end

        local cmd = { "go", "run" }
        local args = split_args(input)
        if #args == 0 then
            args = { "." }
        end
        vim.list_extend(cmd, args)
        open_go_term(cmd)
    end)
end

---Run `go test` with interactive args input
---@return nil
function M.test_interactive()
    vim.ui.input({ prompt = "go test args: ", default = "./..." }, function(input)
        if input == nil then
            return
        end

        local cmd = { "go", "test" }
        local args = split_args(input)
        if #args == 0 then
            args = { "./..." }
        end
        vim.list_extend(cmd, args)
        open_go_term(cmd)
    end)
end

---Run `go test ./...`
---@return nil
function M.test_all()
    open_go_term({ "go", "test", "./..." })
end

---Run `go fmt ./...`
---@return nil
function M.format_all()
    open_go_term({ "go", "fmt", "./..." })
end

return M
