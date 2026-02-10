==================
Plugins Overview
==================

This configuration uses a minimal set of carefully curated plugins. Each serves a specific purpose.

Plugin List
===========

+-------------------+-------------------------------------------+-----------+
| Plugin            | Purpose                                   | File      |
+===================+===========================================+===========+
| vim-plug          | Plugin manager                            | install.py|
+-------------------+-------------------------------------------+-----------+
| nvim-lspconfig    | LSP configuration                         | lsp/      |
+-------------------+-------------------------------------------+-----------+
| zuban             | Python Language Server                    | lsp/      |
+-------------------+-------------------------------------------+-----------+
| nvim-treesitter   | Syntax highlighting & parsing             | plugin/   |
+-------------------+-------------------------------------------+-----------+
| fzf-lua           | Fuzzy finder integration                  | plugin/   |
+-------------------+-------------------------------------------+-----------+
| ayu.vim           | Color scheme                              | plugin/   |
+-------------------+-------------------------------------------+-----------+
| gitsigns.nvim     | Git decorations                           | plugin/   |
+-------------------+-------------------------------------------+-----------+
| indent-blankline  | Indentation guides                        | plugin/   |
+-------------------+-------------------------------------------+-----------+
| leap.nvim         | Fast movement                             | plugin/   |
+-------------------+-------------------------------------------+-----------+
| which-key.nvim    | Keybinding helper                         | plugin/   |
+-------------------+-------------------------------------------+-----------+

Detailed Plugin Descriptions
============================

vim-plug (Plugin Manager)
------------------------

**What it does**: Manages plugin installation and updates.

**Why used**: Lightweight and simple, with no external dependencies.

**Configuration**: Auto-installed by ``install.py``. Update with ``:PlugUpdate``.

nvim-lspconfig
--------------

**What it does**: Provides configuration for various language servers.

**Why used**: Standard way to set up LSP in Neovim.

**Configuration**: In ``lua/lsp/lsp.lua``. Connects to Zuban for Python.

**Key features**:

- Easy server setup
- Built-in defaults
- Hooks for customization

Zuban (Python Language Server)
------------------------------

**What it does**: Provides intelligent Python language features.

**Features**:

- Code completion
- Go to definition
- Find references
- Rename refactoring
- Type checking
- Hover information

**Why used**: Fast (written in Rust), reliable, active development.

**Installation**: Installed by ``install.py`` in the virtual environment.

**Configuration**: In ``lua/lsp/lsp.lua``.

Treesitter
----------

**What it does**: Provides syntax highlighting and code understanding.

**Features**:

- Precise syntax highlighting (better than regex-based)
- Code structure understanding
- Text objects (select functions, blocks, etc.)
- Incremental parsing (fast)

**Why used**: Modern approach to highlighting, faster and more accurate.

**Parsers installed**:

- python
- lua
- vim
- comment
- vimdoc
- c
- sql
- query

**Configuration**: ``lua/plugin/treesitter.lua``

**Install more parsers**:

.. code-block:: vim

    :TSInstall javascript typescript

fzf-lua
-------

**What it does**: Integrates FZF (fuzzy finder) into Neovim.

**Features**:

- Find files
- Search buffers
- Search git files
- Search file contents
- Live preview
- Multi-selection

**Why used**: FZF is extremely fast and integrates well with git workflows.

**Configuration**: ``lua/plugin/fzf-lua.lua``

**Commands**:

- ``<C-f>`` - Files
- ``<C-b>`` - Buffers
- ``<C-g>`` - Git files
- ``<leader>r`` - Search contents

See :doc:`fzf_guide` for detailed usage.

ayu.vim (Color Scheme)
---------------------

**What it does**: Provides the Ayu color scheme.

**Features**:

- Clean, modern colors
- Good contrast
- Comfortable for long coding sessions
- Supports light, dark, and mirage variants

**Why used**: Modern, well-maintained colorscheme with good Python highlighting.

**Configuration**: ``lua/plugin/ayu.lua``

**Alternatives**: Change ``colorscheme`` to use any installed scheme:

.. code-block:: lua

    vim.cmd.colorscheme("monokai")  -- Use Monokai instead

gitsigns.nvim
-------------

**What it does**: Shows git changes in the editor.

**Features**:

- Displays added/modified/deleted lines
- Shows git diff
- Navigate hunks
- Stage hunks

**Why used**: Quick visual feedback on what you've changed.

**Configuration**: ``lua/plugin/gitsigns.lua``

**Keybindings**:

- ``]c`` - Next hunk
- ``[c`` - Previous hunk
- ``<leader>hs`` - Stage hunk
- ``<leader>hu`` - Undo hunk

indent-blankline.nvim
---------------------

**What it does**: Shows vertical lines for indentation.

**Features**:

- Visual indentation guides
- Helps see code structure
- Lightweight
- Configurable characters

**Why used**: Improves readability for nested code.

**Configuration**: ``lua/plugin/indent_blankline.lua``

**Customization**:

.. code-block:: lua

    char = "│"     -- Change the line character
    char = "│" | "┆"  -- Or use alternatives

leap.nvim
---------

**What it does**: Provides fast movement to any character on screen.

**Features**:

- Type target characters to jump
- Works in visual and operator modes
- Precise positioning

**Why used**: Faster than hjkl for long-distance movement.

**Usage**:

1. Press ``s``
2. Type two characters where you want to go
3. Press Enter to jump

**Configuration**: ``lua/plugin/leap.lua``

which-key.nvim
--------------

**What it does**: Shows keybinding menu and organizes keybindings.

**Features**:

- Discoverable keybindings
- Organized by prefix
- Shows descriptions
- Keyboard navigation

**Why used**: Helps you remember and discover keybindings.

**Most important file**: ``lua/plugin/which-key.lua`` - This is where you add custom keybindings.

**Usage**: Press ``<leader>`` and wait to see all available commands.

Why These Plugins?
==================

The plugin selection follows these principles:

1. **Minimal** - Only what's necessary
2. **Focused** - Each plugin does one thing well
3. **Lightweight** - Fast startup and execution
4. **Maintained** - Active development
5. **Integrated** - Work well together

**Not included** (and why):

- **File browser** - FZF is better
- **Airline** - Custom status line is simpler
- **COC/Vim-LSP** - nvim-lspconfig is built-in standard
- **vim-autopairs** - Configuration complexity not worth it
- **vim-easymotion** - Leap does same thing better

Plugin Management
=================

**Installation**:

Handled by ``install.py`` and vim-plug. Manual:

.. code-block:: vim

    :PlugInstall

**Update**:

.. code-block:: vim

    :PlugUpdate

**Remove**:

1. Edit ``init.lua`` to remove the require/require line
2. Run ``:PlugClean``

**Check status**:

.. code-block:: vim

    :PlugStatus

Adding a Plugin
===============

To add a new plugin:

1. **Edit ``init.lua``** to require/require the plugin

2. **Create configuration** in ``lua/plugin/my_plugin.lua``

3. **Add keybindings** to ``lua/plugin/which-key.lua``

Example: Adding ``vim-commentary``

.. code-block:: lua

    -- In init.lua
    require('lua.plugin.my_plugin')

    -- In lua/plugin/my_plugin.lua
    require('comment').setup()

    -- In lua/plugin/which-key.lua
    wk.add({
        { "<leader>/", "<Plug>(comment_toggle_linewise)", desc = "Toggle comment" }
    })

Removing a Plugin
=================

1. **Remove from ``init.lua``** - Delete the require line
2. **Delete the config file** - Remove ``lua/plugin/my_plugin.lua``
3. **Remove keybindings** - Delete from ``which-key.lua``
4. **Clean up** in Neovim:

   .. code-block:: vim

       :PlugClean

Replacing a Plugin
==================

**Example: Replace leap with vim-easymotion**

1. Install new plugin via vim-plug
2. Add configuration for new plugin
3. Remove old plugin's keybindings
4. Add new plugin's keybindings
5. Remove old plugin requirement from ``init.lua``
6. Run ``:PlugClean``

Plugin Compatibility
====================

Most Lua plugins for Neovim are compatible. Check:

- **Neovim version** - Need >= 0.5 (we have 0.11.4)
- **Dependencies** - Some need additional tools
- **Conflicting plugins** - Avoid duplicate functionality

Performance Tips
================

- **Lazy load** plugins if possible
- **Disable by default** plugins you rarely use
- **Use lightweight** alternatives
- **Profile** if startup is slow: ``nvim --startuptime log.txt``

Updating Plugins Safely
=======================

Before updating:

.. code-block:: bash

    git add .
    git commit -m "Before plugin update"

Then update:

.. code-block:: vim

    :PlugUpdate

If something breaks:

.. code-block:: bash

    git checkout -

Recommended Reading
===================

- See :doc:`customization` for how to modify plugins
- See :doc:`plugins` for plugin configurations
- Visit plugin repositories for detailed documentation

Common Plugin Tasks
===================

**Reinstall a plugin**:

.. code-block:: vim

    :PlugClean
    :PlugInstall

**Check for plugin errors**:

.. code-block:: vim

    :checkhealth

**See what plugins are loaded**:

.. code-block:: vim

    :scriptnames

**Find plugin documentation**:

.. code-block:: vim

    :help plugin_name
