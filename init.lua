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
        ft = "python",
        config = function()
            require("lsp")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("plugin.treesitter")
        end,
    },
    {
        "ibhagwan/fzf-lua",
        config = function()
            require("plugin.fzf-lua")
        end,
    },
    {
        "Shatur/neovim-ayu",
        lazy = false,
        priority = 1000,
        config = function()
            require("plugin.ayu")
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("plugin.gitsigns")
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            require("plugin.indent_blankline")
        end,
    },
    {
        "kylechui/nvim-surround",
        config = true,
    },
    {
        "ggandor/leap.nvim",
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
