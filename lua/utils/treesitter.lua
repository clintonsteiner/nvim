local M = {}

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
