function save_session()
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

function toggle_text_wrap()
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

function toggle_diagnostics()
    local current_setting = vim.diagnostic.config().virtual_text
    vim.diagnostic.config({virtual_text = not current_setting, signs = not current_setting, underline = not current_setting})
end
