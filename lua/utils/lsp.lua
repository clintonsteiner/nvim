---LSP install missing functionality
---@class LspInstall
local M = {}

M.auto_install_checked_ft = {}

local ft_to_mason_packages = require('config.mason_packages')

---Check if lazy is loaded
---@return boolean
local function ensure_mason_loaded()
    local ok, lazy = pcall(require, "lazy")
    if not ok then
        return false
    end
    lazy.load({ plugins = { "mason.nvim", "mason-lspconfig.nvim", "mason-tool-installer.nvim" } })
    return true
end

---Install missing Mason packages for filetype
---@param ft string Filetype to install for
---@param opts table? Options table
function M.install_missing_for_filetype(ft, opts)
    opts = opts or {}
    local notify_result = opts.notify_result ~= false
    local notify_errors = opts.notify_errors ~= false
    local packages = ft_to_mason_packages[ft]

    if not packages or #packages == 0 then
        if notify_result then
            vim.notify("No Mason-managed LSP package configured for filetype '" .. ft .. "'.", vim.log.levels.INFO)
        end
        return
    end

    if not ensure_mason_loaded() then
        if notify_errors then
            vim.notify("Could not load lazy.nvim to initialize Mason.", vim.log.levels.ERROR)
        end
        return
    end

    local ok_registry, registry = pcall(require, "mason-registry")
    if not ok_registry then
        if notify_errors then
            vim.notify("Mason registry unavailable. Run :Lazy sync and try again.", vim.log.levels.ERROR)
        end
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

        if notify_result then
            local level = #unavailable > 0 and vim.log.levels.WARN or vim.log.levels.INFO
            vim.notify(table.concat(lines, "\n"), level, { title = "LspInstallMissing" })
        elseif notify_errors and #unavailable > 0 then
            vim.notify(
                "Mason package(s) missing from registry: " .. table.concat(unavailable, ", "),
                vim.log.levels.WARN,
                { title = "LspInstallMissing" }
            )
        end
    end

    local ok_refresh = pcall(registry.refresh, install_packages)
    if not ok_refresh then
        install_packages()
    end
end

return M
