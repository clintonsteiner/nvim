local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local mason_tool_installer = require("mason-tool-installer")

-- Set JAVA_HOME for groovyls build on systems with JDK 21
vim.env.JAVA_HOME = "/usr/lib/jvm/java-21-openjdk"

mason.setup({})

mason_lspconfig.setup({
    ensure_installed = {
        "groovyls",
        "clangd",
        "ts_ls",
        "rust_analyzer",
        "jdtls",
        "jsonls",
        "yamlls",
        "bashls",
        "marksman",
        "taplo",
    },
    automatic_enable = false,
})

mason_tool_installer.setup({
    run_on_start = true,
    auto_update = false,
    start_delay = 1500,
    integrations = {
        ["mason-lspconfig"] = true,
    },
})
