require("neorg").setup({
    load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {
            config = {
                icon_preset = "varied",
            },
        },
        ["core.dirman"] = {
            config = {
                workspaces = {
                    notes = "~/notes",
                },
                default_workspace = "notes",
            },
        },
        ["core.keybinds"] = {
            config = {
                default_keybinds = true,
                neorg_leader = "<Leader>n",
            },
        },
        ["core.journal"] = {
            config = {
                journal_folder = "journal",
                strategy = "nested",
            },
        },
        ["core.export"] = {},
        ["core.summary"] = {},
        ["core.tangle"] = {},
    },
})
