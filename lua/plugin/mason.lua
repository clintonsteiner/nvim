local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local mason_tool_installer = require("mason-tool-installer")

mason.setup({})

mason_lspconfig.setup({
    ensure_installed = {
        "gopls",
        "groovyls",
        "clangd",
        "sqls",
        "ts_ls",
        "rust_analyzer",
        "jdtls",
        "jsonls",
        "yamlls",
    },
    automatic_installation = true,
})

mason_tool_installer.setup({
    run_on_start = true,
    auto_update = false,
    start_delay = 1500,
    integrations = {
        ["mason-lspconfig"] = true,
    },
})
