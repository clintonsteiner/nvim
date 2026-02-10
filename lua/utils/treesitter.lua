---@class TreesitterUtils
---Tree-Sitter based utility functions for code analysis
local M = {}

---Get the name of the current function being edited
---Uses Tree-Sitter to parse and navigate the AST to find the enclosing function
---@return string The function name, or empty string if not in a function or not Python
function M.get_current_function_name()
    if vim.bo.filetype ~= "python" then return "" end
    local current_node = vim.treesitter.get_node()
    if not current_node then return "" end

    local expr = current_node
    while expr do
        if expr:type() == 'function_definition' then
            break
        end
        expr = expr:parent()
    end
    if not expr then return "" end

    local success, result = pcall(vim.treesitter.get_node_text, expr:child(1), 0)
    return success and result or ""
end

---Get the name of the current class being edited
---Uses Tree-Sitter to parse and navigate the AST to find the enclosing class
---@return string The class name, or empty string if not in a class or not Python
function M.get_current_class_name()
    if vim.bo.filetype ~= "python" then return "" end
    local current_node = vim.treesitter.get_node()
    if not current_node then return "" end

    local expr = current_node
    while expr do
        if expr:type() == 'class_definition' then
            break
        end
        expr = expr:parent()
    end
    if not expr then return "" end

    local success, result = pcall(vim.treesitter.get_node_text, expr:child(1), 0)
    return success and result or ""
end

return M
