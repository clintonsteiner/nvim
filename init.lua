vim.g.python3_host_prog = vim.env.HOME .. "/.virtualenvs/nvim/bin/python3"
vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason-lspconfig.nvim",
        },
        ft = {
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
        config = function()
            require("lsp")
        end,
    },
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = {},
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        dependencies = {
            "williamboman/mason.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        config = function()
            require("plugin.mason")
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
        },
        config = function()
            require("plugin.cmp")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("plugin.treesitter")
        end,
    },
    {
        "ibhagwan/fzf-lua",
        cmd = "FzfLua",
        config = function()
            require("plugin.fzf-lua")
        end,
    },
    {
        "Shatur/neovim-ayu",
        event = "VeryLazy",
        config = function()
            require("plugin.ayu")
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("plugin.gitsigns")
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("plugin.indent_blankline")
        end,
    },
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = true,
    },
    {
        "https://codeberg.org/andyg/leap.nvim",
        event = "VeryLazy",
        config = function()
            require("plugin.leap")
        end,
    },
    {
        "numToStr/FTerm.nvim",
        event = "VeryLazy",
        config = function()
            require("plugin.fterm")
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("plugin.which-key")
        end,
    },
})

-- load modules ------------------------------------------------------------------------------------
require "settings"
require "autocmds"
require "statusline"
require "disable_plugins"
require "utils.core"
require "utils.treesitter"
