============
LSP Features
============

The configuration uses Zuban as the Python Language Server, providing advanced code intelligence.

What is LSP?
============

Language Server Protocol (LSP) provides:

- **Code Completion** - Suggestions as you type
- **Go to Definition** - Jump to where something is defined
- **Find References** - Find all uses of a symbol
- **Diagnostics** - Real-time error and warning highlighting
- **Hover Information** - See documentation without leaving your code
- **Rename Refactoring** - Rename symbols across the project
- **Code Formatting** - Integrated with darker

Zuban Language Server
=====================

This configuration uses **Zuban**, a Python language server written in Rust.

**Why Zuban?**

- Fast performance (written in Rust)
- Reliable type checking
- Good support for modern Python (3.8+)
- Minimal dependencies
- Active maintenance

**Installation**:

Zuban is installed automatically by the setup script. To verify:

.. code-block:: bash

    ~/.virtualenvs/nvim/bin/python -m pip list | grep zuban

If not installed:

.. code-block:: bash

    ~/.virtualenvs/nvim/bin/pip install zuban

Activating LSP
==============

LSP automatically activates when you open a Python file. Check status with:

.. code-block:: vim

    :checkhealth lsp

**Indicators**:

- LSP is active if you see checkmarks in `:checkhealth lsp`
- The status line shows LSP activity
- Diagnostics (errors/warnings) appear as colored underlines

Hover Information
=================

Hover over any symbol to see documentation:

.. code-block:: vim

    K

This shows:

- Function/class documentation
- Type information
- Parameter details
- Source file location

Go to Definition
================

Jump to where a symbol is defined:

.. code-block:: vim

    gd

**Example**:

.. code-block:: python

    def my_function():
        result = helper_function()  # Place cursor here and press 'gd'
        # Jumps to where helper_function is defined

**Go to declaration** (declaration vs definition):

.. code-block:: vim

    gD

For most cases, ``gd`` and ``gD`` are equivalent. Declarations are where a symbol is first mentioned, definitions are where it's fully implemented.

Find References
===============

Find all places where a symbol is used:

.. code-block:: vim

    gr

This opens a list of all references. Use FZF to filter and select:

.. code-block:: python

    def my_function():  # Press 'gr' here
        pass

    my_function()  # Reference 1
    my_function()  # Reference 2

**Quickfix list**: References appear in a searchable list. Navigate with arrow keys and press Enter to jump.

Code Completion
===============

Get code suggestions:

.. code-block:: vim

    <C-x><C-o>

In insert mode, the LSP provides completions for:

- Function names
- Class names
- Module imports
- Variable names
- Methods on objects

**Example**:

.. code-block:: python

    import os
    os.pat  # Press <C-x><C-o> to see suggestions (path, pathconf, etc.)

Diagnostics
===========

The LSP shows errors and warnings inline:

.. code-block:: python

    undefined_variable  # Red underline shows error
    print("unused")  # Yellow underline shows warning

**View diagnostics**:

.. code-block:: vim

    <leader>d

Toggle diagnostics on and off.

**Navigate between diagnostics**:

.. code-block:: vim

    ]d    " Next diagnostic
    [d    " Previous diagnostic

**See all diagnostics** in current file:

.. code-block:: vim

    :diagnose

Rename Refactoring
==================

Safely rename symbols across the project:

.. code-block:: vim

    <leader>rn

**Example**:

1. Position cursor on ``old_name``
2. Press ``<leader>rn``
3. Type new name
4. Press Enter to apply

All occurrences update automatically.

**Why LSP rename is better than find-and-replace**:

- Understands code structure
- Renames only the specific symbol, not similar names
- Updates all scopes (imports, usages, definitions)

Code Formatting
===============

Format your code with darker (integrated with LSP):

.. code-block:: vim

    <leader>f

LSP-powered formatting:

- **Black style** - Modern Python formatting
- **isort** - Import organization
- **Line length** - 140 characters (configurable)
- **Diff mode** - Only changes what changed

Workspace Symbols
=================

Search for symbols (functions, classes) in the workspace:

.. code-block:: vim

    <leader>s

This searches across all files in the project.

Document Symbols
================

View all symbols in the current file:

.. code-block:: vim

    <leader>ds

Useful for navigating large files.

Signature Help
==============

See function signatures as you type:

.. code-block:: vim

    <C-k>

In insert mode while typing function arguments, shows the function signature with parameter details.

**Example**:

.. code-block:: python

    def greet(name: str, greeting: str = "Hello"):
        return f"{greeting}, {name}"

    greet(  # Press <C-k> to see: (name: str, greeting: str = "Hello")

Configuration
=============

LSP is configured in ``lua/lsp/lsp.lua``. Key settings:

- **Python executable** - Points to your virtual environment
- **Server settings** - Zuban-specific options
- **Diagnostics** - What to show/hide

To modify LSP behavior, edit this file.

Type Checking
=============

Zuban provides type information for:

- Type hints (e.g., ``def foo(x: int) -> str:``)
- Return types
- Variable types

Hover over any symbol to see inferred types:

.. code-block:: vim

    K

Troubleshooting LSP
===================

**LSP not activating**:

1. Check Zuban is installed:

   .. code-block:: bash

       ~/.virtualenvs/nvim/bin/pip list | grep zuban

2. Restart Neovim
3. Run `:checkhealth lsp`

**Go to definition not working**:

- May not work for builtin types (that's normal)
- Works best for user-defined functions and classes
- May not work for dynamically created symbols

**Completions not showing**:

1. Press ``<C-x><C-o>`` explicitly
2. Or use a completion plugin for automatic suggestions
3. Check `:checkhealth lsp` for errors

**Slow performance**:

- LSP may take a moment to analyze large files
- Try closing unused files
- Check `:checkhealth` for memory issues

Performance Tips
================

- **Exclude directories** - Configure LSP to skip large directories
- **Limit diagnostics** - Turn off expensive checks
- **Use lazy loading** - LSP loads only for Python files

For detailed configuration, see :doc:`lsp_configuration`.

LSP and Other Tools
====================

Zuban works alongside:

- **Ruff** - Fast linting (error checking)
- **Darker** - Code formatting
- **Treesitter** - Syntax highlighting

Each tool serves a specific purpose:

- LSP: Navigation, completion, type info
- Ruff: Linting and style checking
- Darker: Code formatting
- Treesitter: Visual highlighting

Keyboard Shortcuts Summary
==========================

+-------------------+-------------------------------------------+
| Key               | Action                                    |
+===================+===========================================+
| ``K``             | Show documentation/type info              |
+-------------------+-------------------------------------------+
| ``gd``            | Go to definition                          |
+-------------------+-------------------------------------------+
| ``gD``            | Go to declaration                         |
+-------------------+-------------------------------------------+
| ``gr``            | Find all references                       |
+-------------------+-------------------------------------------+
| ``<leader>rn``    | Rename symbol                             |
+-------------------+-------------------------------------------+
| ``<C-k>``         | Show signature help                       |
+-------------------+-------------------------------------------+
| ``<C-x><C-o>``    | Code completion                           |
+-------------------+-------------------------------------------+
| ``]d``            | Next diagnostic                           |
+-------------------+-------------------------------------------+
| ``[d``            | Previous diagnostic                       |
+-------------------+-------------------------------------------+

See :doc:`lsp_configuration` for detailed configuration options.
