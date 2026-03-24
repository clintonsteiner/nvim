---Shared filetype lists for LSP and autocommand configuration
---@class Filetypes
local M = {}

---Python filetypes
M.python = { "python" }

---Go filetypes
M.go = { "go", "gomod", "gowork", "gosum" }

---Groovy filetypes
M.groovy = { "groovy" }

---C/C++ filetypes
M.c_cpp = { "c", "cpp", "objc", "objcpp", "cuda", "proto" }

---SQL filetypes
M.sql = { "sql", "mysql", "plsql" }

---JavaScript/TypeScript filetypes
M.javascript = { "javascript", "javascriptreact", "typescript", "typescriptreact" }

---Rust filetypes
M.rust = { "rust" }

---Java filetypes
M.java = { "java" }

---JSON filetypes
M.json = { "json", "jsonc" }

---YAML filetypes
M.yaml = { "yaml" }

---Shell filetypes
M.shell = { "sh", "bash", "zsh" }

---TOML filetypes
M.toml = { "toml" }

---Markdown filetypes
M.markdown = { "markdown" }

---All LSP-enabled filetypes (for LspAttach and missing LSP warnings)
M.lsp_enabled = {
    "python",
    "go", "gomod", "gowork", "gosum",
    "groovy",
    "c", "cpp",
    "sql",
    "javascript", "javascriptreact",
    "typescript", "typescriptreact",
    "rust",
    "java",
    "json", "jsonc",
    "yaml",
    "sh", "bash", "zsh",
    "toml",
    "markdown",
}

return M
