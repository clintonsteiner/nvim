-- completion options
vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'popup' }
vim.opt.pumheight = 20

-- probe for Java 21 and set JAVA_HOME globally for groovyls
local function setup_java_home()
    local java21_paths = {
        "/usr/lib/jvm/java-21-openjdk",
        "/usr/lib/jvm/java-21-openjdk-amd64",
        "/usr/lib/jvm/java-21-openjdk-arm64",
    }
    for _, path in ipairs(java21_paths) do
        if vim.fn.isdirectory(path) == 1 then
            vim.env.JAVA_HOME = path
            break
        end
    end
end
setup_java_home()

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

local cmd_cache = {}
local function resolve_cmd(bin_name, extra_args, preferred_path)
    local cache_key = bin_name .. (preferred_path or "")
    if cmd_cache[cache_key] then
        return cmd_cache[cache_key]
    end

    local cmd_path = nil

    if preferred_path and vim.fn.executable(preferred_path) == 1 then
        cmd_path = preferred_path
    else
        local system_path = vim.fn.exepath(bin_name)
        if system_path ~= "" then
            cmd_path = system_path
        else
            local go_bin_path = vim.env.HOME .. "/go/bin/" .. bin_name
            if vim.fn.executable(go_bin_path) == 1 then
                cmd_path = go_bin_path
            else
                local mason_path = mason_bin .. "/" .. bin_name
                if vim.fn.executable(mason_path) == 1 then
                    cmd_path = mason_path
                end
            end
        end
    end

    local result = nil
    if cmd_path then
        result = { cmd_path }
        if extra_args then
            vim.list_extend(result, extra_args)
        end
    end

    cmd_cache[cache_key] = result
    return result
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

local java_workspace_cache = nil
local function get_java_workspace()
    if java_workspace_cache then
        return java_workspace_cache
    end

    local project = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    java_workspace_cache = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project
    vim.fn.mkdir(java_workspace_cache, "p")
    return java_workspace_cache
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
    cmd_env = vim.env.JAVA_HOME and { JAVA_HOME = vim.env.JAVA_HOME } or nil,
})

-- clangd server for c/c++
register_server("clangd", {
    cmd = resolve_cmd("clangd"),
    root_dir = root_with_fallback('compile_commands.json', 'compile_flags.txt', 'CMakeLists.txt', '.git'),
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
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

-- turn off diagnostics by default, use simple config without complex debouncing
vim.diagnostic.config({
    virtual_text = false,
    signs = false,
    underline = false,
})
