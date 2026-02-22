---@class CoreUtils
---Core utility functions for general Neovim operations
local M = {}

---Save current Neovim session to file
---@return nil
function M.save_session()
    vim.ui.input({
        prompt = "Session name: ",
        default = '~/.local/share/nvim/sessions/',
        completion = 'file'
    },
    function(sessionName)
        if (sessionName ~= "" and sessionName ~= nil) then
            vim.fn.execute('mksession! ' .. vim.fn.fnameescape(sessionName))
        end
    end
    )
end

---Toggle text wrapping on/off
---Toggles between 100 character width and no wrapping
---@return nil
function M.toggle_text_wrap()
    local current_setting = vim.o.textwidth
    if current_setting == 0 then
        current_setting = 100
        print("text wrap on")
    else
        current_setting = 0
        print("text wrap off")
    end
    vim.o.textwidth = current_setting
end

---Toggle diagnostic display
---Toggles virtual text, signs, and underline for diagnostics
---@return nil
function M.toggle_diagnostics()
    local current_setting = vim.diagnostic.config().virtual_text
    vim.diagnostic.config({virtual_text = not current_setting, signs = not current_setting, underline = not current_setting})
end

---Toggle LSP inlay hints for the current buffer
---@return nil
function M.toggle_inlay_hints()
    local bufnr = vim.api.nvim_get_current_buf()
    local current = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
    vim.lsp.inlay_hint.enable(not current, { bufnr = bufnr })
end

return M
