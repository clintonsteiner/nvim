====================
Configuration Structure
====================

This document explains the organization of the configuration files.

Directory Layout
================

.. code-block:: text

    ~/dotfiles/nvim/
    ├── init.lua                      # Main entry point
    ├── lua/                          # Lua configuration
    │   ├── autocmds.lua             # Autocommands and event handlers
    │   ├── settings.lua             # Basic editor settings (tabs, indentation, etc.)
    │   ├── statusline.lua           # Custom status line
    │   ├── lsp/                     # Language Server Protocol
    │   │   ├── init.lua             # LSP initialization
    │   │   └── lsp.lua              # Zuban LSP configuration
    │   ├── plugin/                  # Plugin configurations
    │   │   ├── ayu.lua              # Ayu colorscheme
    │   │   ├── fzf-lua.lua          # FZF fuzzy finder
    │   │   ├── gitsigns.lua         # Git decorations
    │   │   ├── indent_blankline.lua # Indentation guides
    │   │   ├── leap.lua             # Fast movement
    │   │   ├── treesitter.lua       # Treesitter highlighting
    │   │   └── which-key.lua        # Keybinding menu
    │   ├── disable_plugins.lua      # Disables default plugins
    │   └── utils/                   # Utility functions
    │       ├── core.lua             # Core utilities
    │       ├── python.lua           # Python-specific utilities
    │       └── treesitter.lua       # Treesitter helpers
    ├── install.py                    # Automated setup script
    ├── pyproject.toml               # Python dependencies
    ├── README.md                    # Main documentation
    └── docs/                        # Sphinx documentation (this folder)

init.lua - Main Entry Point
============================

The ``init.lua`` file is the main configuration file. It:

1. Loads basic settings
2. Initializes the LSP
3. Configures plugins
4. Sets up keybindings

**Never edit init.lua directly** - instead, modify the specific files it requires.

lua/settings.lua - Editor Settings
===================================

Basic Neovim settings:

- Tab width and indentation
- Line numbering
- Search settings
- Split behavior
- Clipboard configuration

**To modify**: Edit ``lua/settings.lua`` and reload Neovim.

lua/statusline.lua - Custom Status Line
========================================

A custom status line showing:

- Current file name
- Cursor position
- Git branch (if in repo)
- LSP status
- Diagnostic count

The status line is lightweight and fast - no plugin needed.

**To customize**: Edit this file and reload Neovim. The file is well-commented.

lua/autocmds.lua - Autocommands
================================

Automatically triggered actions:

- Format on save
- Update diagnostics
- Auto-save certain file types
- Custom event handlers

**To add new autocommand**: Add to this file following the existing patterns.

lua/lsp/ - Language Server Configuration
=========================================

**init.lua**: Initializes LSP capabilities.

**lsp.lua**: Configures Zuban for Python:

- Server settings
- Diagnostic configuration
- Completion setup
- Hover behavior

**To add another language server**: Edit ``lsp.lua`` and add configuration for that language.

Example:

.. code-block:: lua

    -- In lua/lsp/lsp.lua
    lsp.go:setup({})  -- Add Go language server

lua/plugin/ - Plugin Configurations
====================================

Each plugin has its own file:

**ayu.lua** - Colorscheme

- Sets the color scheme
- Customizes highlight groups
- Adjusts colors for readability

**fzf-lua.lua** - Fuzzy Finder

- Configures FZF behavior
- Sets search paths
- Customizes preview window
- Maps FZF commands

**gitsigns.lua** - Git Integration

- Shows git changes in line numbers
- Marks added/modified/deleted lines
- Provides git hunks navigation

**indent_blankline.lua** - Indentation Guides

- Shows vertical lines for indentation levels
- Helps visualize code structure

**leap.lua** - Fast Movement

- Quick motion to any location
- Type target characters to jump

**treesitter.lua** - Syntax Highlighting

- Configures Treesitter parsers
- Sets highlighting rules
- Manages parser installation

**which-key.lua** - Keybinding Menu

- Organizes all keybindings
- Shows menu on ``<leader>`` press
- Most important file for customization

lua/utils/ - Utility Functions
==============================

Reusable code shared across the config.

**core.lua** - Core Utilities

- Helper functions
- Common patterns
- Utility functions used by other modules

**python.lua** - Python Utilities

- Python-specific helpers
- Test running
- Code formatting utilities

**treesitter.lua** - Treesitter Helpers

- Parser detection
- Language-specific utilities

lua/disable_plugins.lua - Disable Built-ins
==========================================

Disables Neovim's built-in plugins:

- ``netrw`` - File browser (we use FZF instead)
- Other defaults we don't use

This keeps Neovim lean and fast.

install.py - Setup Script
===========================

Automated installation:

- Downloads Neovim
- Sets up Python environment
- Installs dependencies
- Creates symlinks
- Installs plugins

Run once: ``python3 install.py``

pyproject.toml - Python Dependencies
====================================

Python packages required in the virtual environment:

- pynvim - Python bindings for Neovim
- zuban - Python Language Server
- ruff - Linter
- darker - Code formatter

See :doc:`python_dependencies` for details.

How Files Work Together
=======================

**Startup sequence**:

1. Neovim launches
2. Loads ``init.lua``
3. ``init.lua`` requires all other configuration files
4. Settings, LSP, plugins, keybindings all activate
5. You can start editing

**When you edit a file**:

1. Autocommands trigger
2. LSP analyzes code
3. Treesitter highlights syntax
4. Status line updates
5. Diagnostics appear

**When you press a keybinding**:

1. Which-key menu shows (if you press ``<leader>``)
2. Plugin command executes
3. LSP action happens (if LSP-related)
4. Result appears in editor

Understanding Dependencies
===========================

Some files depend on others:

- All files depend on ``settings.lua`` (basic setup)
- LSP files depend on each other
- Plugin files are somewhat independent
- Utilities are used by multiple files

**If you remove a file**: Other files may break. For example:

- Removing ``utils/core.lua`` breaks any plugin using it
- Removing ``lsp/lsp.lua`` disables all language features
- Removing ``plugin/which-key.lua`` disables keybindings

Adding New Plugins
==================

To add a new plugin:

1. Create ``lua/plugin/my_plugin.lua``
2. Require it in ``init.lua``
3. Configure the plugin in the new file
4. Add keybindings to ``which-key.lua``

Example:

.. code-block:: lua

    -- In lua/plugin/my_plugin.lua
    require('my_plugin').setup({
        -- configuration
    })

    -- In init.lua, add:
    require('lua/plugin/my_plugin')

Adding New Settings
===================

Edit ``lua/settings.lua`` to add:

- Indentation rules
- Line width
- Search options
- Behavior settings

Example:

.. code-block:: lua

    vim.opt.textwidth = 88  -- Line width for formatting

Modifying Keybindings
=====================

Edit ``lua/plugin/which-key.lua``:

.. code-block:: lua

    wk.add({
      { "<leader>x", "<cmd>MyCommand<cr>", desc = "My command" }
    })

See :doc:`customization` for detailed examples.

File Naming Conventions
=======================

- ``lua/*.lua`` - Top-level configuration
- ``lua/lsp/*.lua`` - LSP-related
- ``lua/plugin/*.lua`` - Plugin configuration
- ``lua/utils/*.lua`` - Utility functions

Following these conventions keeps the project organized.

Performance Considerations
==========================

The configuration is optimized for:

- **Fast startup** - Minimal lazy loading, quick initialization
- **Responsive editing** - LSP operations don't block
- **Efficient plugins** - Carefully selected, minimal overhead

**To keep performance good**:

- Avoid heavy plugins
- Don't load plugins unless needed
- Use FZF instead of plugin file browsers
- Disable unused language servers

Extending the Configuration
============================

**Best practices**:

1. Create new files in appropriate directories
2. Follow existing code patterns
3. Document your changes
4. Test with `:checkhealth`
5. Keep files focused (one plugin per file)

**Common extensions**:

- Add language server in ``lua/lsp/lsp.lua``
- Add plugin config in ``lua/plugin/``
- Add utilities in ``lua/utils/``
- Add keybindings in ``lua/plugin/which-key.lua``

See :doc:`customization` for detailed examples.

Backup and Version Control
===========================

**Using git**:

.. code-block:: bash

    cd ~/dotfiles/nvim
    git add .
    git commit -m "My customizations"

**Before major changes**:

.. code-block:: bash

    git branch backup-$(date +%Y%m%d)

Debugging Configuration
=======================

If something doesn't work:

1. Check for errors: ``:checkhealth``
2. Look in error log: ``:messages``
3. Check file for syntax errors
4. Verify dependencies are installed

Most issues come from:

- Missing plugins
- Wrong Python environment
- Syntax errors in Lua
- Missing dependencies

See :doc:`troubleshooting` for detailed solutions.
