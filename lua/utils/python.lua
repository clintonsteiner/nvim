---@class PythonUtils
---Python development utilities for Neovim
local M = {}

---Insert common Python abbreviations/snippets
---Provides quick access to common patterns like debugging imports and breakpoints
---@param text string The abbreviation key to expand
---@return nil
function M.abbrev(text)
    local abbrev_text_table = {
        sbreak = '# ' .. string.rep('-', 94),
        lbreak = '# ' .. string.rep('-', 98),
        pdb = 'breakpoint()',
        this = 'import pytest<CR>@pytest.mark.this',
    }
    local cmd = abbrev_text_table[text]
    vim.api.nvim_command(vim.api.nvim_replace_termcodes('normal! O' .. cmd .. '<ESC><CR>', true, false, true))
end

---Generate pytest coverage command for current module
---Constructs the module path from file path and creates a pytest coverage argument
---Example: tests/myapp/test_utils.py -> myapp.test_utils
---@return string The pytest coverage module argument
function M.get_pytest_cov_cmd()
    local cov_cmd = vim.fn.split(vim.fn.substitute(vim.fn.split(vim.fn.expand('%:p:h'), "python/")[2], "/", ".", "g"), ".tests")[1] .. "." .. vim.fn.substitute(vim.fn.substitute(vim.fn.substitute(vim.fn.expand('%'), "test_", "", ""), ".py", "", ""), "tests/", "", "g")
    return cov_cmd
end

---Get pytest argument for running a specific test
---Constructs full path including class and function context
---@return string The pytest path argument (file::class::function)
function M.get_pytest_single_test_arg()
    local utils_treesitter = require('utils.treesitter')
    local pytest_arg = vim.fn.expand('%:p') .. '::' .. utils_treesitter.get_current_class_name() .. '::' .. utils_treesitter.get_current_function_name()
    return pytest_arg
end

---Get the name of the last test that was run
---@return string The file path of the last test (stub implementation)
function M.get_last_test_name()
    -- Stub implementation - returns the current file path
    -- In a real implementation, this would track the last test that was run
    return vim.fn.expand('%:p')
end

---Run darker code formatter on current file
---Formats Python code in-place using darker with isort integration
---Line length preserved at 140 characters
---@return nil
function M.darker()
    vim.api.nvim_command('!' .. vim.g.python3_host_prog .. ' -m darker -iv --color -l 140 -W 4 ' .. vim.fn.expand('%:p'))
end

return M
