require("nvim-tree").setup({
    view = {
        width = 30,
        side = "left",
    },
    renderer = {
        icons = {
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
            },
        },
    },
    filters = {
        dotfiles = false,
        custom = { ".git" },
    },
})
