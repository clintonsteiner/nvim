================
Plugins Overview
================

This config uses ``lazy.nvim`` and loads most plugins on demand.
The goal is practical speed: strong defaults with low startup overhead.

Core Editor UX
==============

+-------------------------------+------------------------------------------+
| Plugin                        | Purpose                                  |
+===============================+==========================================+
| ``folke/which-key.nvim``      | Key discovery and grouped mappings       |
+-------------------------------+------------------------------------------+
| ``ibhagwan/fzf-lua``          | Fast files/grep/git pickers              |
+-------------------------------+------------------------------------------+
| ``nvim-treesitter``           | Syntax tree features                     |
+-------------------------------+------------------------------------------+
| ``lewis6991/gitsigns.nvim``   | Git hunks/signs/blame                    |
+-------------------------------+------------------------------------------+
| ``stevearc/oil.nvim``         | File explorer in a buffer                |
+-------------------------------+------------------------------------------+
| ``folke/noice.nvim`` + notify | Improved messages/UI                     |
+-------------------------------+------------------------------------------+
| ``akinsho/toggleterm.nvim``   | Reusable terminal for tasks/git          |
+-------------------------------+------------------------------------------+

Language and Refactoring
========================

+-------------------------------+------------------------------------------+
| Plugin                        | Purpose                                  |
+===============================+==========================================+
| ``neovim/nvim-lspconfig``     | Built-in LSP configuration               |
+-------------------------------+------------------------------------------+
| ``williamboman/mason.nvim``   | LSP/tool installation                    |
+-------------------------------+------------------------------------------+
| ``hrsh7th/nvim-cmp``          | Completion engine                        |
+-------------------------------+------------------------------------------+
| ``L3MON4D3/LuaSnip``          | Snippets (Go/Python/Jenkins included)    |
+-------------------------------+------------------------------------------+
| ``smjonas/inc-rename.nvim``   | Incremental rename UX                    |
+-------------------------------+------------------------------------------+
| ``ThePrimeagen/refactoring.nvim`` | Extract/inline/refactor actions      |
+-------------------------------+------------------------------------------+
| ``SmiteshP/nvim-navic``       | Breadcrumb context in winbar             |
+-------------------------------+------------------------------------------+
| ``stevearc/aerial.nvim``      | Symbol outline/navigation pane           |
+-------------------------------+------------------------------------------+

Git and Review Workflow
=======================

+-------------------------------+------------------------------------------+
| Plugin                        | Purpose                                  |
+===============================+==========================================+
| ``sindrets/diffview.nvim``    | Side-by-side diff/conflict review        |
+-------------------------------+------------------------------------------+
| ``akinsho/git-conflict.nvim`` | Conflict markers and helpers             |
+-------------------------------+------------------------------------------+
| ``ThePrimeagen/harpoon``      | Fast marked-file jumps                   |
+-------------------------------+------------------------------------------+

Theme and Visuals
=================

+-------------------------------+------------------------------------------+
| Plugin                        | Purpose                                  |
+===============================+==========================================+
| ``Shatur/neovim-ayu``         | Base colorscheme with custom overrides   |
+-------------------------------+------------------------------------------+
| ``lukas-reineke/indent-blankline.nvim`` | Indentation guides             |
+-------------------------------+------------------------------------------+
| ``folke/flash.nvim``          | Fast jump motions                        |
+-------------------------------+------------------------------------------+

Operational Notes
=================

1. Run ``:Lazy sync`` after plugin changes.
2. Run ``:CheckDevEnv`` to verify required language tools.
3. Use ``:ProjectInit`` + ``:ProjectOverrideTrust`` for per-repo task tuning.
