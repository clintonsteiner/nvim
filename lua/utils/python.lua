local M = {}

function M.abbrev(_text)  -- luacheck: ignore 213
    local abbrev_text_table = {
        sbreak = '# ' .. string.rep('-', 94),
        lbreak = '# ' .. string.rep('-', 98),
        pdb = 'breakpoint()',
        this = 'import pytest<CR>@pytest.mark.this',
    }
    local cmd = abbrev_text_table[_text]
    vim.api.nvim_command(vim.api.nvim_replace_termcodes('normal! O' .. cmd .. '<ESC><CR>', true, false, true))
end

function M.get_pytest_cov_cmd()
    local cov_cmd = vim.fn.split(vim.fn.substitute(vim.fn.split(vim.fn.expand('%:p:h'), "python/")[2], "/", ".", "g"), ".tests")[1] .. "." .. vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.expand('%'), "test_", "", ""), ".py", "", ""), "tests/", "", "g")
    return cov_cmd
end

function M.get_pytest_single_test_arg()
    local utils_treesitter = require('utils.treesitter')
    local pytest_arg = vim.fn.expand('%:p') .. '::' .. utils_treesitter.get_current_class_name() .. '::' .. utils_treesitter.get_current_function_name()
    return pytest_arg
end

function M.get_last_test_name()
    -- Stub implementation - returns the current file path
    -- In a real implementation, this would track the last test that was run
    return vim.fn.expand('%:p')
end

function M.darker()
    vim.api.nvim_command('!' .. vim.g.python3_host_prog .. ' -m darker -iv --color -l 140 -W 4 ' .. vim.fn.expand('%:p'))
end

return M
