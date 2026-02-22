local group = vim.api.nvim_create_augroup("MyAutogroups", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank {timeout = 400}
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "python",
    callback = function()
        require("utils.python")
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "lua", "python", "sh", "bash", "zsh", "c", "cpp", "java", "rust", "sql", "groovy" },
    callback = function()
        vim.bo.expandtab = true
        vim.bo.shiftwidth = 4
        vim.bo.tabstop = 4
        vim.bo.softtabstop = 4
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc", "yaml", "toml" },
    callback = function()
        vim.bo.expandtab = true
        vim.bo.shiftwidth = 2
        vim.bo.tabstop = 2
        vim.bo.softtabstop = 2
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "go", "gomod", "gowork", "gosum" },
    callback = function()
        vim.bo.expandtab = false
        vim.bo.shiftwidth = 4
        vim.bo.tabstop = 4
        vim.bo.softtabstop = 4
    end,
})

local function has_lsp_client(bufnr)
    return #vim.lsp.get_clients({ bufnr = bufnr }) > 0
end

local function notify_missing_lsp(bufnr)
    local ok, warned = pcall(vim.api.nvim_buf_get_var, bufnr, "lsp_missing_warned")
    if ok and warned then
        return
    end
    pcall(vim.api.nvim_buf_set_var, bufnr, "lsp_missing_warned", true)
    vim.notify("No LSP client attached for this buffer. Run :LspInfo or :CheckDevEnv.", vim.log.levels.WARN)
end

local function map_lsp(bufnr, lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
        local bufnr = args.buf
        map_lsp(bufnr, "gd", vim.lsp.buf.definition, "Go to definition")
        map_lsp(bufnr, "gD", vim.lsp.buf.declaration, "Go to declaration")
        map_lsp(bufnr, "gr", vim.lsp.buf.references, "Find references")
        map_lsp(bufnr, "gi", vim.lsp.buf.implementation, "Go to implementation")
        map_lsp(bufnr, "K", vim.lsp.buf.hover, "Hover docs")
        map_lsp(bufnr, "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map_lsp(bufnr, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = {
        "python",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "groovy",
        "c",
        "cpp",
        "sql",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "rust",
        "java",
        "json",
        "jsonc",
    },
    callback = function(args)
        local bufnr = args.buf
        vim.defer_fn(function()
            if vim.api.nvim_buf_is_valid(bufnr) and not has_lsp_client(bufnr) then
                notify_missing_lsp(bufnr)
            end
        end, 1200)
    end,
})

vim.api.nvim_create_user_command("CheckDevEnv", function()
    local nvim_venv = vim.env.NVIM_VENV or (vim.env.HOME .. "/.virtualenvs/nvim")
    local checks = {
        { label = "zuban", cmd = nvim_venv .. "/bin/zuban" },
        { label = "ruff", cmd = nvim_venv .. "/bin/ruff" },
        { label = "gopls", cmd = "gopls" },
        { label = "groovy-language-server", cmd = "groovy-language-server" },
        { label = "clangd", cmd = "clangd" },
        { label = "sqls", cmd = "sqls" },
        { label = "typescript-language-server", cmd = "typescript-language-server" },
        { label = "rust-analyzer", cmd = "rust-analyzer" },
        { label = "jdtls", cmd = "jdtls" },
        { label = "vscode-json-language-server", cmd = "vscode-json-language-server" },
    }

    local lines = { "Development environment checks:" }
    local missing = false
    for _, item in ipairs(checks) do
        local ok = vim.fn.executable(item.cmd) == 1
        local status = ok and "OK" or "MISSING"
        table.insert(lines, string.format("%-32s %s", item.label, status))
        if not ok then
            missing = true
        end
    end

    local level = missing and vim.log.levels.WARN or vim.log.levels.INFO
    vim.notify(table.concat(lines, "\n"), level, { title = "CheckDevEnv" })
end, {
    desc = "Check required language-server executables",
})
