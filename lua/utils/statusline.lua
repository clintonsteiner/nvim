---Statusline and winbar utilities
---@class StatuslineUtils
local M = {}

---Get highlight group for current mode
---@param mode string The current mode character
---@return string Highlight group string
function M.get_mode_color(mode)
    local mode_color_table = {
        n = '%#NormalMode#',
        i = '%#InsertMode#',
        R = '%#ReplaceMode#',
        v = '%#VisualMode#',
        V = '%#VisualMode#',
        [''] = '%#VisualMode#',
    }
    return mode_color_table[mode] or '%#OtherMode#'
end

---Get readonly indicator character
---@return string Readonly character or empty string
function M.get_readonly_char()
    if vim.bo.readonly or vim.bo.modifiable == false then
        return ''
    end
    return ''
end

---Get current working directory
---@param shorten boolean Whether to shorten the path
---@return string The current directory path
function M.get_cwd(shorten)
    local dir = vim.api.nvim_call_function('getcwd', {})
    if shorten then
        dir = vim.api.nvim_call_function('pathshorten', {dir})
    end
    return dir
end

---Get gitsigns status for a key
---@param key string The gitsigns status key (head, added, changed, removed)
---@return string Formatted status string
function M.gitsigns_status(key)
    local summary = vim.b.gitsigns_status_dict or {head = '', added = 0, changed = 0, removed = 0}
    if summary[key] == nil or summary[key] == '' or summary[key] == 0 then
        return ''
    end
    local prefix = {head = ' ', added = '+', changed = '~', removed = '-'}
    return string.format(" %s%s ", prefix[key], summary[key])
end

---Get LSP client names for current buffer
---@return string Formatted LSP names string
function M.get_lsp_names()
    local clients = vim.lsp.get_clients()
    local lsps = {}
    for _, client in pairs(clients) do
        table.insert(lsps, client.name)
    end
    if #lsps == 0 then
        return ''
    end
    return '  ' .. table.concat(lsps, "+") .. ' '
end

---Get current class name from treesitter
---@return string Class name or empty string
function M.get_current_class_name()
    local class_name = ""
    local clients = vim.lsp.get_clients()
    if next(clients) ~= nil then
        local utils_treesitter = require('utils.treesitter')
        class_name = utils_treesitter.get_current_class_name()
        if class_name ~= "" then
            class_name = "  " .. class_name .. " "
        end
    end
    return class_name
end

---Get current function name from treesitter
---@return string Function name or empty string
function M.get_current_function_name()
    local func_name = ""
    local clients = vim.lsp.get_clients()
    if next(clients) ~= nil then
        local utils_treesitter = require('utils.treesitter')
        func_name = utils_treesitter.get_current_function_name()
        if func_name ~= "" then
            func_name = "  󰊕 "  .. func_name .. " "
        end
    end
    return func_name
end

---Build statusline string
---@return string The statusline format string
function M.status_line()
    local status = ''
    status = status .. M.get_mode_color(vim.fn.mode()) .. [[ %-"]]  -- luacheck: ignore 143
    status = status .. [[%#GitSignsAdd#%-{luaeval("require('utils.statusline').gitsigns_status('head')")}]]
    status = status .. [[%#GitSignsAdd#%-{luaeval("require('utils.statusline').gitsigns_status('added')")}]]
    status = status .. [[%#GitSignsChange#%-{luaeval("require('utils.statusline').gitsigns_status('changed')")}]]
    status = status .. [[%#GitSignsDelete#%-{luaeval("require('utils.statusline').gitsigns_status('removed')")}]]
    status = status .. '%#Directory# '
    status = status .. '%='
    status = status .. [[%-{luaeval("require('utils.statusline').get_cwd(false)")} ]]
    status = status .. [[%#WildMenu#%-{luaeval("require('utils.statusline').get_lsp_names()")}]]
    return status
end

---Build winbar string
---@return string The winbar format string
function M.win_bar()
    local file_path = vim.fn.expand('%:~:.:h')
    local file_name = vim.fn.expand('%:t')
    local value = ' '

    file_path = file_path:gsub('^%.', '')
    file_path = file_path:gsub('^%/', '')

    if not (file_name == nil or file_name == '' or string.sub(file_path, 1, 5) == 'term:') then
        local file_icon = ' '
        file_icon = '%#WinBarIcon#' .. file_icon .. '%*'
        local file_modified = ''
        if vim.bo.modified then
            file_modified = '%#WinBarModified#%*'
        end
        value = value .. file_icon .. file_name .. ' ' .. file_modified ..
            ' %-{luaeval("require(\'utils.statusline\').get_readonly_char()")}' ..
            '%#NonText#% %#InsertMode#%-{luaeval("require(\'utils.statusline\').get_current_class_name()")}' ..
            '%#CurSearch#%-{luaeval("require(\'utils.statusline\').get_current_function_name()")}' ..
            '%#NonText#%'
    end
    return value
end

return M
