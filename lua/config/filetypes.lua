local M = {}

M.python = { "python" }
M.go = { "go", "gomod", "gowork", "gosum" }
M.groovy = { "groovy" }
M.c_cpp = { "c", "cpp", "objc", "objcpp", "cuda", "proto" }
M.sql = { "sql" }
M.javascript = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
M.rust = { "rust" }
M.java = { "java" }
M.json = { "json", "jsonc" }
M.yaml = { "yaml" }
M.shell = { "sh", "bash", "zsh" }
M.toml = { "toml" }
M.markdown = { "markdown" }
M.lua = { "lua" }

M.four_space = vim.iter({
    M.lua, M.python, M.shell, { "c", "cpp" }, M.java, M.rust, M.sql, M.groovy,
}):flatten():totable()

M.two_space = vim.iter({
    M.javascript, M.json, M.yaml, M.toml,
}):flatten():totable()

M.tab_indent = vim.iter({ M.go }):flatten():totable()

M.no_virtual_text = vim.iter({ M.python, M.go }):flatten():totable()

M.lsp_enabled = vim.iter({
    M.python, M.go, M.groovy, { "c", "cpp" }, M.sql,
    M.javascript, M.rust, M.java, M.json, M.yaml,
    M.shell, M.toml, M.markdown,
}):flatten():totable()

return M
