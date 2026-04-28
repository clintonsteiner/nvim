-- luacheck: ignore 211 (unused variable)
-- Cached values for expensive operations
local cached_lsp_names = ""
local cached_class_name = ""
local cached_func_name = ""

-- Forward declare functions for luacheck
local update_lsp_names, update_treesitter_cache

function get_mode_color(mode)
    local mode_color = '%#OtherMode#'
    local mode_color_table = {
        n = '%#NormalMode#',
        i = '%#InsertMode#',
        R = '%#ReplaceMode#',
        v = '%#VisualMode#',
        V = '%#VisualMode#',
        [''] = '%#VisualMode#',
    }
    if mode_color_table[mode] then
        mode_color = mode_color_table[mode]
    end
    return mode_color
end

function get_readonly_char()
    local ro_char = ''
    if vim.bo.readonly or vim.bo.modifiable == false then ro_char = '' end
    return ro_char
end

function get_cwd(shorten)
    local dir = vim.api.nvim_call_function('getcwd', {})
    if shorten then
        dir = vim.api.nvim_call_function('pathshorten', {dir})
    end
    return dir
end

function gitsigns_status(key)
    local summary = vim.b.gitsigns_status_dict or {head = '', added = 0, changed = 0, removed = 0}
    if summary[key] == nil then return '' end
    if summary[key] == '' then return '' end
    if summary[key] == 0 then return '' end
    local prefix = {head = ' ', added = '+', changed = '~', removed = '-'}
    return string.format(" %s%s ", prefix[key], summary[key])
end

function get_lsp_names()
    return cached_lsp_names
end

function update_lsp_names()
    local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
    local lsps = {}
    for _, client in pairs(clients) do
        table.insert(lsps, client.name)
    end
    cached_lsp_names = ""
    if #lsps > 0 then
        cached_lsp_names = "  " .. table.concat(lsps, "+") .. " "
    end
end

function _get_current_class_name()
    return cached_class_name
end

function _get_current_function_name()
    return cached_func_name
end

function update_treesitter_cache()
    if vim.bo.filetype ~= "python" then
        cached_class_name = ""
        cached_func_name = ""
        return
    end

    local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
    if not next(clients) then
        cached_class_name = ""
        cached_func_name = ""
        return
    end

    local ok, utils_treesitter = pcall(require, 'utils.treesitter')
    if not ok then
        return
    end

    local class_name = utils_treesitter.get_current_class_name()
    cached_class_name = ""
    if class_name ~= "" then
        cached_class_name = "  " .. class_name .. " "
    end

    local func_name = utils_treesitter.get_current_function_name()
    cached_func_name = ""
    if func_name ~= nil and func_name ~= "" then
        cached_func_name = "  󰊕 "  .. func_name .. " "
    end
end

function status_line()
    local status = ''
    status = status .. get_mode_color(vim.fn.mode()) .. [[ %-"]]  -- luacheck: ignore 143  -- luacheck: ignore 143
    status = status .. [[%#GitSignsAdd#%-{luaeval("gitsigns_status('head')")}]]
    status = status .. [[%#GitSignsAdd#%-{luaeval("gitsigns_status('added')")}]]
    status = status .. [[%#GitSignsChange#%-{luaeval("gitsigns_status('changed')")}]]
    status = status .. [[%#GitSignsDelete#%-{luaeval("gitsigns_status('removed')")}]]
    status = status .. '%#Directory# '
    status = status .. '%='
    status = status .. [[%-{luaeval("get_cwd(false)")} ]]
    status = status .. [[%#WildMenu#%-{luaeval("get_lsp_names()")}]]
    return status
end

vim.opt.statusline = '%!luaeval("status_line()")'

-- winbar
function win_bar()
    local file_path = vim.fn.expand('%:~:.:h')
    local file_name = vim.fn.expand('%:t')
    local value = ' '

    file_path = file_path:gsub('^%.', '')
    file_path = file_path:gsub('^%/', '')

    if not (file_name == nil or file_name == '' or string.sub(file_path, 1, 5) == 'term:') then
        local file_icon = ' '
        file_icon = '%#WinBarIcon#' .. file_icon .. '%*'
        local file_modified = ''
        if vim.bo.modified then
            file_modified = '%#WinBarModified#%*'
        end
        value = value .. file_icon .. file_name .. ' ' .. file_modified .. ' %-{luaeval("get_readonly_char()")}%#NonText#% %#InsertMode#%-{luaeval("_get_current_class_name()")}%#CurSearch#%-{luaeval("_get_current_function_name()")}%#NonText#%'
    end
    return value
end

vim.opt.winbar = '%!luaeval("win_bar()")'
vim.opt.laststatus = 3

-- Set up event handlers to update caches
local group = vim.api.nvim_create_augroup("StatuslineCaches", { clear = true })

vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
    group = group,
    callback = function()
        update_lsp_names()
    end,
})

vim.api.nvim_create_autocmd("CursorMoved", {
    group = group,
    callback = function()
        update_treesitter_cache()
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function()
        cached_class_name = ""
        cached_func_name = ""
        update_lsp_names()
    end,
})

-- Initial update on startup
vim.schedule(function()
    update_lsp_names()
    update_treesitter_cache()
end)
