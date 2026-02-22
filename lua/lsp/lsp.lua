-- completion options
vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'popup' }
vim.opt.pumheight = 20

-- zuban lsp server
local nvim_venv = vim.env.NVIM_VENV or (vim.env.HOME .. '/.virtualenvs/nvim')
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
local lspconfig = require("lspconfig")
local util = lspconfig.util
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

local function resolve_cmd(bin_name, extra_args, preferred_path)
    local cmd_path = nil

    if preferred_path and vim.fn.executable(preferred_path) == 1 then
        cmd_path = preferred_path
    else
        local system_path = vim.fn.exepath(bin_name)
        if system_path ~= "" then
            cmd_path = system_path
        else
            local mason_path = mason_bin .. "/" .. bin_name
            if vim.fn.executable(mason_path) == 1 then
                cmd_path = mason_path
            end
        end
    end

    if not cmd_path then
        return nil
    end

    local cmd = { cmd_path }
    if extra_args then
        vim.list_extend(cmd, extra_args)
    end
    return cmd
end

local function root_with_fallback(...)
    local matcher = util.root_pattern(...)
    return function(bufnr, on_dir)
        local name = vim.api.nvim_buf_get_name(bufnr)
        local root = matcher(name)
        if root and root ~= "" then
            on_dir(root)
            return
        end
        on_dir(vim.fs.dirname(name))
    end
end

local function register_server(name, config)
    if not config.cmd then
        return
    end
    vim.lsp.config[name] = config
    vim.lsp.enable(name)
end

local function get_java_workspace()
    local project = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    local workspace = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project
    vim.fn.mkdir(workspace, "p")
    return workspace
end

register_server("zuban", {
    cmd = resolve_cmd("zuban", { "server" }, nvim_venv .. '/bin/zuban'),
    root_dir = root_with_fallback('.git', 'pyproject.toml', 'setup.py'),
    filetypes = { "python" },
    capabilities = capabilities,
    settings = {},
    on_attach = function(client, _bufnr)  -- luacheck: ignore 213
        client.server_capabilities.semanticTokensProvider = false  -- disable this as it seems to mess with treesitter highlighting at the moment
        client.server_capabilities.diagnosticProvider = false  -- will use ruff for this
    end,
})

-- ruff lsp server
register_server("ruff", {
    cmd = resolve_cmd("ruff", { "server" }, nvim_venv .. '/bin/ruff'),
    root_dir = root_with_fallback('.git', 'pyproject.toml', 'setup.py'),
    filetypes = { "python" },
    capabilities = capabilities,
    init_options = {
        settings = {
            lint = {
                ignore = {"E501"},  -- ignore line length error
                extendSelect = {"W291", "W293"},  -- whitespace warnings
                -- TODO add to extendSelect when available: E1120, ...
                -- see astral-sh / ruff / issues / 970
            },
        },
    },
    on_attach = function(client, _bufnr)  -- luacheck: ignore 213
        client.server_capabilities.hoverProvider = false
    end,
})

-- gopls server
register_server("gopls", {
    cmd = resolve_cmd("gopls"),
    root_dir = root_with_fallback('go.work', 'go.mod', '.git'),
    filetypes = { "go", "gomod", "gowork", "gosum" },
    capabilities = capabilities,
    settings = {
        gopls = {
            gofumpt = true,
            usePlaceholders = true,
            staticcheck = true,
        },
    },
})

-- groovy lsp server
register_server("groovyls", {
    cmd = resolve_cmd("groovy-language-server"),
    root_dir = root_with_fallback('gradlew', 'pom.xml', 'build.gradle', 'build.gradle.kts', '.git'),
    filetypes = { "groovy" },
    capabilities = capabilities,
})

-- clangd server for c/c++
register_server("clangd", {
    cmd = resolve_cmd("clangd"),
    root_dir = root_with_fallback('compile_commands.json', 'compile_flags.txt', 'CMakeLists.txt', '.git'),
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    capabilities = capabilities,
})

-- sql language server
register_server("sqls", {
    cmd = resolve_cmd("sqls"),
    root_dir = root_with_fallback('.sqls.yml', '.git'),
    filetypes = { "sql", "mysql", "plsql" },
    capabilities = capabilities,
})

-- typescript/javascript language server (npm projects supported via package.json roots)
register_server("ts_ls", {
    cmd = resolve_cmd("typescript-language-server", { "--stdio" }),
    root_dir = root_with_fallback('tsconfig.json', 'jsconfig.json', 'package.json', '.git'),
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    capabilities = capabilities,
})

-- rust language server
register_server("rust_analyzer", {
    cmd = resolve_cmd("rust-analyzer"),
    root_dir = root_with_fallback('Cargo.toml', 'rust-project.json', '.git'),
    filetypes = { "rust" },
    capabilities = capabilities,
})

-- java language server
register_server("jdtls", {
    cmd = resolve_cmd("jdtls", { "-data", get_java_workspace() }),
    root_dir = root_with_fallback('pom.xml', 'build.gradle', 'build.gradle.kts', '.git'),
    filetypes = { "java" },
    capabilities = capabilities,
})

-- json language server
register_server("jsonls", {
    cmd = resolve_cmd("vscode-json-language-server", { "--stdio" }),
    root_dir = root_with_fallback('package.json', '.git'),
    filetypes = { "json", "jsonc" },
    capabilities = capabilities,
})

-- yaml language server
register_server("yamlls", {
    cmd = resolve_cmd("yaml-language-server", { "--stdio" }),
    root_dir = root_with_fallback('.yamllint', '.git'),
    filetypes = { "yaml" },
    capabilities = capabilities,
})

-- shell language server
register_server("bashls", {
    cmd = resolve_cmd("bash-language-server", { "start" }),
    root_dir = root_with_fallback('.git'),
    filetypes = { "sh", "bash", "zsh" },
    capabilities = capabilities,
})

-- markdown language server
register_server("marksman", {
    cmd = resolve_cmd("marksman", { "server" }),
    root_dir = root_with_fallback('.git'),
    filetypes = { "markdown" },
    capabilities = capabilities,
})

-- toml language server
register_server("taplo", {
    cmd = resolve_cmd("taplo", { "lsp", "stdio" }),
    root_dir = root_with_fallback('pyproject.toml', 'Cargo.toml', '.git'),
    filetypes = { "toml" },
    capabilities = capabilities,
})

-- turn off diagnostics by default
vim.diagnostic.config({
    virtual_text = false,
    signs = false,
    underline = false,
})
