==========
Quick Start
==========

Get up and running with your Neovim environment in just a few minutes.

30-Second Setup
===============

.. code-block:: bash

    git clone https://github.com/clintonsteiner/nvim.git ~/dotfiles/nvim
    cd ~/dotfiles/nvim
    python3 install.py
    # Answer 'y' to each prompt
    nvim  # Launch Neovim

Your Neovim configuration is now ready!

First Launch
============

When you launch Neovim for the first time, you'll see:

1. **Plugin installation** - Press `y` to install all plugins
2. **Treesitter parsers** - The script will offer to install language parsers
3. **LSP activation** - The LSP will activate automatically for Python files

Check that everything is working:

.. code-block:: vim

    :checkhealth

Essential Keybindings
=====================

Press ``<leader>`` (space by default) and wait to see all available commands. Here are the most useful ones:

**File Navigation**:

- ``<C-f>`` - Find files
- ``<C-b>`` - Switch between open buffers
- ``<C-g>`` - Search git files

**Python Development**:

- ``<leader>t`` - Run tests on current file
- ``<leader>f`` - Format code with darker
- ``gd`` - Go to definition
- ``gr`` - Find all references

**Text Editing**:

- ``<leader>w`` - Toggle line wrapping
- ``<leader>d`` - Toggle diagnostic messages

For a complete list, see :doc:`keybindings`.

Opening a Python Project
========================

To work on a Python project:

.. code-block:: bash

    cd /path/to/your/python/project
    nvim

The LSP will automatically activate and provide:

- Code completion
- Go to definition
- Find references
- Inline diagnostics
- Code formatting

Running Tests
=============

To run tests on your current Python file:

.. code-block:: vim

    <leader>t

Or to run a specific test function:

.. code-block:: vim

    <leader>T

The output appears in a floating terminal at the bottom of the screen.

Formatting Code
===============

Format your current Python file with:

.. code-block:: vim

    <leader>f

Darker preserves your line length and style preferences. Configuration is in ``pyproject.toml``.

Finding Things with FZF
=======================

FZF is deeply integrated for fast searching:

- ``<C-f>`` - Search files by name
- ``<C-b>`` - Search open buffers
- ``<C-g>`` - Search git files
- ``<leader>r`` - Search file contents

Type to filter, use arrow keys to navigate, press Enter to select.

Next Steps
==========

After your initial setup, consider:

1. **Customize keybindings** - Edit ``lua/plugin/which-key.lua``
2. **Add language servers** - Edit ``lua/lsp/lsp.lua`` for other languages
3. **Configure plugins** - Modify files in ``lua/plugin/``
4. **Read the full documentation** - See :doc:`customization` for detailed options

Need Help?
==========

If something doesn't work:

1. Run ``:checkhealth`` in Neovim
2. Check the :doc:`troubleshooting` guide
3. Review the README.md in the repository

Common Issues and Fixes
=======================

**LSP not working**:

.. code-block:: bash

    ~/.virtualenvs/nvim/bin/python -m pip install zuban

**FZF commands not responding**:

.. code-block:: bash

    brew install fzf ripgrep

**Missing syntax highlighting**:

.. code-block:: vim

    :TSInstall python lua comment

See :doc:`troubleshooting` for more detailed solutions.
