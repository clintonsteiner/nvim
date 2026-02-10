==============
Customization
==============

This guide covers how to customize the configuration for your needs.

Modifying Keybindings
=====================

All keybindings are in ``lua/plugin/which-key.lua``. This is the file you'll edit most often.

**Adding a keybinding**:

1. Open ``lua/plugin/which-key.lua``
2. Find the appropriate section
3. Add your keybinding:

.. code-block:: lua

    wk.add({
      { "<leader>x", "<cmd>MyCommand<cr>", desc = "Do something" }
    })

**Example 1: Add a keybinding to run a custom command**

.. code-block:: lua

    -- In lua/plugin/which-key.lua, add:
    wk.add({
      { "<leader>m", "<cmd>Make<cr>", desc = "Run make" }
    })

Now ``<leader>m`` runs the ``make`` command.

**Example 2: Add a keybinding to execute a shell command**

.. code-block:: lua

    wk.add({
      { "<leader>sh", "<cmd>!sh /path/to/script.sh<cr>", desc = "Run my script" }
    })

**Example 3: Add a keybinding to call a Lua function**

.. code-block:: lua

    wk.add({
      { "<leader>z", function() my_custom_function() end, desc = "My function" }
    })

**Removing a keybinding**:

Simply delete or comment out the line in ``which-key.lua``.

Changing the Leader Key
=======================

The leader key is set in ``lua/settings.lua``:

.. code-block:: lua

    vim.g.mapleader = " "  -- Space is the leader key

Change to a different key:

.. code-block:: lua

    vim.g.mapleader = ","  -- Use comma instead

Common choices:

- Space (default) - Reach with thumb
- Comma - Easy for keyboard
- Semicolon - QWERTY layout friendly

Customizing Appearance
======================

**Color scheme**:

Edit ``lua/plugin/ayu.lua`` to change the theme:

.. code-block:: lua

    vim.cmd.colorscheme("ayu")  -- Change "ayu" to another scheme

Requires the colorscheme to be installed.

**Font size** (terminal setting, not Neovim):

- macOS: Terminal > Preferences > Profiles > Text
- Linux: Right-click > Preferences or Settings > Appearance
- Windows: Not supported (use WSL2)

**Line numbers**:

In ``lua/settings.lua``:

.. code-block:: lua

    vim.opt.number = true      -- Show line numbers
    vim.opt.relativenumber = true  -- Show relative numbers

**Status line**:

The status line is in ``lua/statusline.lua``. Modify to show different info.

**Indentation guides** (vertical lines):

In ``lua/plugin/indent_blankline.lua``:

.. code-block:: lua

    require('ibl').setup({
        indent = { char = '│' }  -- Change character
    })

Editing Python Configuration
=============================

**Tab width**:

In ``lua/settings.lua``:

.. code-block:: lua

    vim.opt.tabstop = 4       -- Display width of tab
    vim.opt.shiftwidth = 4    -- Indentation width

**Code formatter settings**:

Edit ``pyproject.toml``:

.. code-block:: toml

    [tool.darker]
    line_length = 100  # Default is 140

    [tool.isort]
    profile = "black"

**Python linter settings** (Ruff):

Edit ``pyproject.toml``:

.. code-block:: toml

    [tool.ruff]
    line-length = 100
    select = ["E", "W", "F"]  # What errors to check

**LSP settings**:

Edit ``lua/lsp/lsp.lua`` to customize:

- Type checking level
- Diagnostic settings
- Completion options

Example:

.. code-block:: lua

    -- Make diagnostics less aggressive
    vim.diagnostic.config({
        virtual_text = false,  -- Don't show inline diagnostics
        signs = true,
        underline = true,
    })

Adding a New Language Server
=============================

To add support for another language:

1. Install the language server
2. Add configuration to ``lua/lsp/lsp.lua``

**Example: Add TypeScript support**

.. code-block:: bash

    npm install -g typescript-language-server

Then in ``lua/lsp/lsp.lua``:

.. code-block:: lua

    -- Add after Zuban setup
    local lspconfig = require('lspconfig')
    lspconfig.tsserver.setup({
        capabilities = capabilities,
        on_attach = on_attach,
    })

Customizing FZF
===============

FZF configuration is in ``lua/plugin/fzf-lua.lua``.

**Change search directories**:

.. code-block:: lua

    -- Search only in src/ directory
    require('fzf-lua').setup({
        files = {
            cwd = 'src/'
        }
    })

**Ignore directories**:

.. code-block:: lua

    require('fzf-lua').setup({
        files = {
            exclude = 'node_modules',
        }
    })

**Change preview window size**:

.. code-block:: lua

    require('fzf-lua').setup({
        fzf_opts = {
            ['--preview-window'] = 'right:40%'
        }
    })

Adding Custom Functions
=======================

Create a new utility file and use it in your config.

**Example: Add a custom Python command**

1. Create ``lua/utils/my_utils.lua``:

.. code-block:: lua

    local M = {}

    function M.run_black()
        vim.cmd('!black %')
    end

    return M

2. Use in ``lua/plugin/which-key.lua``:

.. code-block:: lua

    local my_utils = require('utils.my_utils')

    wk.add({
        { "<leader>b", function() my_utils.run_black() end, desc = "Format with Black" }
    })

Adding a Plugin
===============

To add a new plugin (e.g., ``vim-surround``):

1. Update your plugin manager configuration
2. Install the plugin
3. Configure it in a new file in ``lua/plugin/``
4. Require it in ``init.lua``

**Example: Add telescope for advanced searching**

Many users replace FZF with telescope. To add it:

1. Install telescope (use your plugin manager)
2. Create ``lua/plugin/telescope.lua``:

.. code-block:: lua

    require('telescope').setup({
        defaults = {
            file_ignore_patterns = {'node_modules', '.git'}
        }
    })

3. Add to ``init.lua``:

.. code-block:: lua

    require('lua.plugin.telescope')

4. Add keybindings in ``which-key.lua``

Changing LSP Diagnostic Display
================================

Control how diagnostics appear:

.. code-block:: lua

    -- In lua/lsp/lsp.lua
    vim.diagnostic.config({
        virtual_text = false,     -- No inline error messages
        underline = true,          -- Keep underlines
        signs = true,              -- Show signs in gutter
        update_in_insert = false,  -- Don't update while typing
    })

Making Neovim Faster
====================

**Profile startup time**:

.. code-block:: bash

    nvim --startuptime startup.log +q

Check ``startup.log`` for slow plugins.

**Lazy load plugins**:

In plugin configuration, use lazy loading:

.. code-block:: lua

    require('plugin').setup({
        lazy = true,  -- Load only when needed
    })

**Disable unused plugins**:

In ``lua/disable_plugins.lua``, disable defaults you don't use.

Customizing Text Wrapping
==========================

Enable wrapping by default:

.. code-block:: lua

    -- In lua/settings.lua
    vim.opt.wrap = true
    vim.opt.linebreak = true  -- Break on words, not characters

**Visual indicator at column**:

.. code-block:: lua

    vim.opt.colorcolumn = "88"  -- Show line at column 88

Changing Font for Symbols
==========================

Icons come from the colorscheme. To use different icons:

1. Change the colorscheme in ``lua/plugin/ayu.lua``
2. Or customize the colorscheme to use different Unicode characters

**Without a Nerd Font**:

Icons won't display correctly. Install a Nerd Font from:
https://www.nerdfonts.com/

Custom Autocommands
====================

Add custom actions in ``lua/autocmds.lua``.

**Example: Auto-format on save**

.. code-block:: lua

    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.py",
        callback = function()
            vim.cmd("Format")  -- Or your formatter command
        end
    })

**Example: Set filetype for custom files**

.. code-block:: lua

    vim.api.nvim_create_autocmd("BufNewFile,BufRead", {
        pattern = "*.myext",
        callback = function()
            vim.bo.filetype = "python"
        end
    })

Creating a Configuration Backup
================================

Before major changes, save your configuration:

.. code-block:: bash

    cd ~/dotfiles/nvim
    git branch backup-$(date +%Y%m%d)
    git add .
    git commit -m "Pre-customization backup"

If something breaks:

.. code-block:: bash

    git checkout backup-YYYYMMDD

Reloading Configuration
=======================

After editing config files:

1. Reload all: ``:luafile %``
2. Or restart Neovim completely

Some changes (like new keybindings) take effect immediately. Others need a restart.

Testing Customizations
======================

When adding customizations:

1. Save your change
2. Reload configuration (or restart)
3. Test the feature: ``:checkhealth`` for diagnostics
4. Check `:messages`` for errors

Common Customization Patterns
=============================

**Pattern 1: Change default behavior**

1. Find the setting in a config file
2. Edit the value
3. Reload/restart

**Pattern 2: Add new command**

1. Create function in ``lua/utils/``
2. Add keybinding in ``which-key.lua``
3. Test the new command

**Pattern 3: Replace a plugin**

1. Add new plugin configuration to ``lua/plugin/``
2. Remove old plugin's keybindings from ``which-key.lua``
3. Test that new plugin works

**Pattern 4: Disable a feature**

1. Comment out or delete from relevant file
2. Remove associated keybindings
3. Restart Neovim

Troubleshooting Customizations
==============================

**Error after editing**:

1. Check syntax with ``:checkhealth``
2. Look at error message with ``:messages``
3. Fix the syntax error
4. Reload with ``:luafile %`` or restart

**Keybinding doesn't work**:

1. Verify syntax in ``which-key.lua``
2. Check with ``:map <leader>x`` to see if it's mapped
3. Ensure the command exists
4. Restart Neovim

**Plugin not loading**:

1. Verify it's required in ``init.lua``
2. Check for errors: ``:messages``
3. Verify plugin is installed
4. Restart Neovim

For more help, see :doc:`troubleshooting`.

Sharing Customizations
======================

Save your customized config to git:

.. code-block:: bash

    cd ~/dotfiles/nvim
    git add .
    git commit -m "My customizations"
    git push

Now you can easily set up the same config on another machine:

.. code-block:: bash

    git clone https://github.com/yourusername/nvim.git ~/dotfiles/nvim
    cd ~/dotfiles/nvim
    python3 install.py
