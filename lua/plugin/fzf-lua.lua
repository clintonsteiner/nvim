local actions = require'fzf-lua.actions'

-- Define a fallback highlight group for FZF if NotifyDEBUGTitle doesn't exist
local fzf_hl = "Statement"
if vim.fn.hlID("NotifyDEBUGTitle") ~= 0 then
    fzf_hl = "NotifyDEBUGTitle"
end

require'fzf-lua'.setup {
    actions = {
        files = {
            -- open multiple-selected files in separate buffers vs. quickfix
            ["default"] = actions.file_edit,
            ["ctrl-s"] = actions.file_split,
            ["ctrl-v"] = actions.file_vsplit,
            ["ctrl-t"] = actions.file_tabedit,
            ["alt-q"] = actions.file_sel_to_qf,
        },
    },
    fzf_colors = {
        ["fg"] = {"fg", "Normal"},
        ["bg"] = {"bg", "Normal"},
        ["hl"] = {"fg", fzf_hl},
        ["fg+"] = {"fg", fzf_hl},
        ["bg+"] = {"bg", "CursorLine"},
        ["hl+"] = {"fg", "CursorLineNr"},
        ["info"] = {"fg", "Identifier"},
        ["prompt"] = {"fg", fzf_hl},
        ["pointer"] = {"fg", "Normal"},
        ["marker"] = {"fg", "Identifier"},
        ["spinner"] = {"fg", "Identifier"},
        ["header"] = {"fg", "Constant"},
        ["gutter"] = "-1",
        ["selected-fg"] = {"fg", "Constant"},
        ["selected-bg"] = {"bg", "WinBar"},
    },
    fzf_opts = {
        ["--highlight-line"] = true,
        ["--marker"] = "▏ ",
        ["--pointer"] = "▌ ",
    },
    nbsp = '\xc2\xa0',
    helptags = {
        fzf_opts = {
            ["--delimiter"] = "[ ]",
        },
    },
}
vim.api.nvim_cmd({cmd = 'normal', args = {'FzfLua register_ui_select'}}, {})

function git_show_diff(selected)
    if not selected or #selected == 0 then
        return
    end
    local commit_hash = selected[1]:match("[^ ]+")
    if not commit_hash then
        vim.notify("Failed to extract commit hash", vim.log.levels.ERROR)
        return
    end
    local cmd = {"git", "show", commit_hash}
    local git_file_contents = vim.fn.systemlist(cmd)
    local file_name = string.gsub(vim.fn.expand("%:p"), "$", "[" .. commit_hash .. "]")
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_lines(buf, 0, 0, true, git_file_contents)
    vim.api.nvim_buf_set_name(buf, file_name)
    vim.bo[buf].filetype = 'git'
    vim.bo[buf].modifiable = false
    vim.api.nvim_win_set_buf(win, buf)
end
