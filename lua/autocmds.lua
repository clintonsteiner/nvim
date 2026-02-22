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

local function cmd_label(cmd)
    if type(cmd) == "table" then
        return tostring(cmd[1] or "")
    end
    return tostring(cmd or "")
end

local function configured_servers_for_ft(filetype)
    local ok, configs = pcall(vim.lsp.get_configs)
    if not ok or type(configs) ~= "table" then
        return {}, {}
    end

    local available = {}
    local missing = {}

    for name, config in pairs(configs) do
        local fts = config.filetypes or {}
        if vim.tbl_contains(fts, filetype) then
            local cmd = cmd_label(config.cmd)
            local executable = cmd ~= "" and vim.fn.executable(cmd) == 1
            if executable then
                table.insert(available, name)
            else
                table.insert(missing, name)
            end
        end
    end

    table.sort(available)
    table.sort(missing)
    return available, missing
end

local function notify_missing_lsp(bufnr)
    local ok, warned = pcall(vim.api.nvim_buf_get_var, bufnr, "lsp_missing_warned")
    if ok and warned then
        return
    end
    pcall(vim.api.nvim_buf_set_var, bufnr, "lsp_missing_warned", true)

    local ft = vim.bo[bufnr].filetype
    local available, missing = configured_servers_for_ft(ft)
    if #available == 0 and #missing == 0 then
        return
    end

    if #available > 0 then
        vim.notify(
            "No LSP client attached for '" .. ft .. "'. Configured servers: " .. table.concat(available, ", ")
                .. ". Run :LspInfo.",
            vim.log.levels.WARN
        )
        return
    end

    vim.notify(
        "No LSP client attached for '" .. ft .. "'. Missing binaries for: "
            .. table.concat(missing, ", ")
            .. ". Run :CheckDevEnv.",
        vim.log.levels.WARN
    )
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
        "yaml",
        "sh",
        "bash",
        "zsh",
        "toml",
        "markdown",
    },
    callback = function(args)
        local bufnr = args.buf
        local delay_ms = tonumber(vim.g.lsp_missing_warn_delay_ms) or 2500
        if vim.g.lsp_missing_warn_enabled == false then
            return
        end
        vim.defer_fn(function()
            if vim.api.nvim_buf_is_valid(bufnr) and not has_lsp_client(bufnr) then
                notify_missing_lsp(bufnr)
            end
        end, delay_ms)
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
        { label = "yaml-language-server", cmd = "yaml-language-server" },
        { label = "bash-language-server", cmd = "bash-language-server" },
        { label = "marksman", cmd = "marksman" },
        { label = "taplo", cmd = "taplo" },
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

local ft_to_mason_packages = {
    go = { "gopls" },
    gomod = { "gopls" },
    gowork = { "gopls" },
    gosum = { "gopls" },
    groovy = { "groovyls" },
    c = { "clangd" },
    cpp = { "clangd" },
    sql = { "sqls" },
    javascript = { "ts_ls" },
    javascriptreact = { "ts_ls" },
    typescript = { "ts_ls" },
    typescriptreact = { "ts_ls" },
    rust = { "rust_analyzer" },
    java = { "jdtls" },
    json = { "jsonls" },
    jsonc = { "jsonls" },
    yaml = { "yamlls" },
    sh = { "bashls" },
    bash = { "bashls" },
    zsh = { "bashls" },
    toml = { "taplo" },
    markdown = { "marksman" },
}

local function ensure_mason_loaded()
    local ok, lazy = pcall(require, "lazy")
    if not ok then
        return false
    end
    lazy.load({ plugins = { "mason.nvim", "mason-lspconfig.nvim", "mason-tool-installer.nvim" } })
    return true
end

vim.api.nvim_create_user_command("LspInstallMissing", function()
    local ft = vim.bo.filetype
    local packages = ft_to_mason_packages[ft]

    if not packages or #packages == 0 then
        vim.notify("No Mason-managed LSP package configured for filetype '" .. ft .. "'.", vim.log.levels.INFO)
        return
    end

    if not ensure_mason_loaded() then
        vim.notify("Could not load lazy.nvim to initialize Mason.", vim.log.levels.ERROR)
        return
    end

    local ok_registry, registry = pcall(require, "mason-registry")
    if not ok_registry then
        vim.notify("Mason registry unavailable. Run :Lazy sync and try again.", vim.log.levels.ERROR)
        return
    end

    local function install_packages()
        local installed = {}
        local installing = {}
        local unavailable = {}

        for _, name in ipairs(packages) do
            local ok_pkg, pkg = pcall(registry.get_package, name)
            if not ok_pkg then
                table.insert(unavailable, name)
            elseif pkg:is_installed() then
                table.insert(installed, name)
            else
                pkg:install()
                table.insert(installing, name)
            end
        end

        local lines = { "LSP install check for '" .. ft .. "':" }
        if #installed > 0 then
            table.insert(lines, "already installed: " .. table.concat(installed, ", "))
        end
        if #installing > 0 then
            table.insert(lines, "installing: " .. table.concat(installing, ", "))
        end
        if #unavailable > 0 then
            table.insert(lines, "not found in Mason registry: " .. table.concat(unavailable, ", "))
        end

        local level = #unavailable > 0 and vim.log.levels.WARN or vim.log.levels.INFO
        vim.notify(table.concat(lines, "\n"), level, { title = "LspInstallMissing" })
    end

    local ok_refresh = pcall(registry.refresh, install_packages)
    if not ok_refresh then
        install_packages()
    end
end, {
    desc = "Install missing Mason LSP packages for current filetype",
})
