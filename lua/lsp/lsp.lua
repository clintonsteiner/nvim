local kind_icons = {
    Text = "",
    Method = "",
    Function = "󰊕",
    Constructor = "",
    Field = "󰜢",
    Variable = "𝒙",
    Class = "",
    Interface = "󰆧",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "󰘍",
    Color = "",
    File = "",
    Reference = "󰌹",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
    Unknown = "?",
}

-- completion options
vim.opt.completeopt = { 'menuone,noselect,popup' }
vim.opt.pumheight = 20

-- zuban lsp server
vim.lsp.config["zuban"] = {
    cmd = { vim.env.HOME .. '/.virtualenvs/nvim/bin/zuban', 'server' },
    root_dir = vim.lsp.util.root_pattern('.git', 'pyproject.toml', 'setup.py'),
    filetypes = { "python" },
    settings = {},
    on_attach = function(client, bufnr)  -- luacheck: ignore 213
        local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
        client.server_capabilities.completionProvider.triggerCharacters = chars
        client.server_capabilities.semanticTokensProvider = false  -- disable this as it seems to mess with treesitter highlighting at the moment
        client.server_capabilities.diagnosticProvider = false  -- will use ruff for this
        -- client.capabilities.textDocument.publishDiagnostics = false  -- will use ruff for this
        vim.lsp.completion.enable(true, client.id, bufnr, {
            autotrigger = true,
            convert = function(item)
                local kind = vim.lsp.protocol.CompletionItemKind[item.kind] or 'Unknown'
                local kind_icon = kind_icons[kind]
                local entry = {
                    abbr = kind_icon .. ' ' .. item.label,
                    kind = kind,
                    -- menu = item.detail or '',  -- enable for big information popups
                    menu = '',
                    icase = 1,
                    dup = 0,
                    empty = 0,
                }
                return entry
            end,
        })
    end,
}
vim.lsp.enable("zuban")

-- ruff lsp server
vim.lsp.config["ruff"] = {
    cmd = { vim.env.HOME .. '/.virtualenvs/nvim/bin/ruff', 'server' },
    root_dir = vim.lsp.util.root_pattern('.git', 'pyproject.toml', 'setup.py'),
    filetypes = { "python" },
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
}
vim.lsp.enable("ruff")

local function keycode(keys)
    return vim.api.nvim_replace_termcodes(keys, true, false, true)
end

local pumMaps = {
    ['<Tab>'] = '<C-n>',
    ['<S-Tab>'] = '<C-p>',
}
for insertKmap, pumKmap in pairs(pumMaps) do
    vim.keymap.set('i', insertKmap, function()
        if vim.fn.pumvisible() == 1 then
            vim.api.nvim_feedkeys(keycode(pumKmap), 'n', false)
        else
            vim.api.nvim_feedkeys(keycode(insertKmap), 'n', false)
        end
    end, { expr = true })
end

-- turn off diagnostics by default
vim.diagnostic.config({
    virtual_text = false,
    signs = false,
    underline = false,
})
