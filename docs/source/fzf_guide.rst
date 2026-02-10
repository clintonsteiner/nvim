==========
FZF Guide
==========

FZF (Fuzzy Finder) is deeply integrated for fast searching. This guide covers all FZF features.

What is FZF?
============

FZF is a command-line fuzzy finder that:

- **Searches fast** - Can find files in huge projects instantly
- **Filters dynamically** - Results update as you type
- **Is flexible** - Works for files, buffers, git files, and more
- **Previews results** - Shows a preview of selected files

Why FZF?
========

Instead of manually navigating directories, FZF lets you:

- Type part of a filename to find it
- Search file contents
- Switch between buffers
- Search git history

Much faster than traditional file browsers.

Finding Files
=============

Find any file by name:

.. code-block:: vim

    <C-f>

Type part of the filename to filter. Use arrow keys to navigate. Press Enter to open.

**Examples**:

- Type ``main.py`` - finds ``main.py``
- Type ``main`` - finds all files with "main" in the name
- Type ``test`` - finds test files

Switching Buffers
==================

Switch between open files:

.. code-block:: vim

    <C-b>

Lists all open buffers. Type to filter by filename. Press Enter to switch.

**Use case**: Quickly flip between ``utils.py`` and ``test_utils.py``.

Searching Git Files
====================

Search in git-tracked files only:

.. code-block:: vim

    <C-g>

Ignores untracked files and directories in ``.gitignore``. Useful for large projects with many ignored files.

**Example**: In a project with ``node_modules/``, ``.git/``, etc., ``<C-g>`` searches only tracked code files.

Searching File Contents
======================

Search for text across the project:

.. code-block:: vim

    <leader>r

Type text to search. Results show:

- Filename
- Line number
- Line content

Navigate results and press Enter to jump to that location.

**Example**: Search for ``def my_function`` to find where a function is defined.

Searching in Selection
======================

Search within the selected text:

.. code-block:: vim

    <leader>s

1. Visually select text
2. Press ``<leader>s``
3. FZF searches only within that text

Using FZF Preview
==================

FZF shows a preview of selected files on the right side:

- Scrollable with arrow keys
- Shows syntax highlighting
- Updates as you navigate

**Toggle preview**:

Press ``?`` in FZF to toggle the preview panel.

FZF Keybindings
================

While in FZF search:

+-------------------+-------------------------------------------+
| Key               | Action                                    |
+===================+===========================================+
| Arrow keys        | Navigate results                          |
+-------------------+-------------------------------------------+
| ``<C-j>/<C-k>``   | Move down/up (alternative)                |
+-------------------+-------------------------------------------+
| ``Enter``         | Select highlighted item                   |
+-------------------+-------------------------------------------+
| ``<C-c>``         | Cancel search                             |
+-------------------+-------------------------------------------+
| ``<C-x>``         | Open in horizontal split                  |
+-------------------+-------------------------------------------+
| ``<C-v>``         | Open in vertical split                    |
+-------------------+-------------------------------------------+
| ``<C-t>``         | Open in new tab                           |
+-------------------+-------------------------------------------+
| ``?``             | Toggle preview                            |
+-------------------+-------------------------------------------+
| ``<C-l>``         | Preview scroll down                       |
+-------------------+-------------------------------------------+
| ``<C-u>``         | Preview scroll up                         |
+-------------------+-------------------------------------------+

FZF Search Syntax
==================

Type in FZF to filter results:

**Exact match**:

.. code-block:: text

    'myfile

Include only results with "myfile" (case-sensitive).

**Invert match**:

.. code-block:: text

    !test

Exclude results containing "test".

**Multiple terms**:

.. code-block:: text

    foo bar

Results matching both "foo" AND "bar".

**Or match**:

.. code-block:: text

    foo | bar

Results matching "foo" OR "bar".

**Regex match** (advanced):

.. code-block:: text

    ^main

Results starting with "main".

Common FZF Patterns
===================

**Find test files**:

.. code-block:: vim

    <C-f>
    test_

Filter shows all test files.

**Find by extension**:

.. code-block:: vim

    <C-f>
    .py

Shows all Python files (note the dot).

**Find with path**:

.. code-block:: vim

    <C-f>
    lua/plugin

Shows files in ``lua/plugin/`` directory.

**Find Python files in a directory**:

.. code-block:: vim

    <C-f>
    src/ .py

Shows Python files in ``src/``.

**Exclude directories**:

.. code-block:: vim

    <C-f>
    !node_modules

Excludes files in ``node_modules/``.

Opening Files Multiple Ways
=============================

In FZF, you can open selected file in different ways:

**Normal (vertical split)**:

Press ``Enter`` - opens in current window (or vertical split if already occupied).

**Horizontal split**:

Press ``<C-x>`` - opens in horizontal split (side by side).

**Vertical split**:

Press ``<C-v>`` - opens in vertical split (top and bottom).

**New tab**:

Press ``<C-t>`` - opens in new tab.

**Use case**:

1. Open ``main.py`` in current window with ``Enter``
2. Open ``test_main.py`` with ``<C-v>`` to see both files

Tips and Tricks
===============

**Quick navigation**:

.. code-block:: vim

    <C-f>
    main.py
    <Enter>

Opens ``main.py`` in under a second (instead of browsing directories).

**Search file contents for function**:

.. code-block:: vim

    <leader>r
    def my_function

Lists all occurrences of the function definition.

**Find recently edited files**:

.. code-block:: vim

    <C-b>

Lists open buffers - shows recently edited files first.

**Open multiple files at once**:

1. Press ``<C-f>`` to find files
2. Select first file
3. Press ``<C-v>`` to open in split
4. Go back to FZF (use file switcher)
5. Select another file
6. Press ``<C-x>`` to open in horizontal split

Performance
===========

FZF is very fast even in large projects because:

- Uses ``ripgrep`` for efficient searching
- Matches happen in real-time
- Scales to 100,000+ files
- Only searches tracked git files by default

**Large project tip**: Use ``<C-g>`` (git files) instead of ``<C-f>`` (all files) in big projects.

Customization
=============

FZF is configured in ``lua/plugin/fzf-lua.lua``. You can customize:

- Preview window size
- Search paths (what to ignore)
- Colors
- Keybindings

See :doc:`customization` for modification examples.

FZF vs LSP Navigation
======================

When to use each:

**Use FZF** (``<C-f>``, ``<leader>r``) for:

- Finding files by name
- Searching file contents
- Finding patterns across project
- Broad searches

**Use LSP** (``gd``, ``gr``) for:

- Going to definition
- Finding references
- Code-aware navigation
- Refactoring

**Example workflow**:

1. ``<C-f>`` - Find file "utils.py"
2. ``gd`` - Jump to function definition in utils.py
3. ``gr`` - Find all places using that function
4. ``<leader>r`` - Search for a specific usage pattern

Integration with Project
========================

FZF respects your project structure:

- Ignores files in ``.gitignore``
- Searches git-tracked files
- Excludes build directories automatically
- Works with git submodules

**Set search paths** in ``lua/plugin/fzf-lua.lua`` to customize what FZF searches.

Common Issues
=============

**FZF not responding**:

Ensure FZF is installed:

.. code-block:: bash

    brew install fzf ripgrep  # macOS
    sudo apt-get install fzf ripgrep  # Linux

**Slow searches**:

Use ``<C-g>`` (git files) instead of ``<C-f>`` (all files) to skip untracked files.

**Preview not showing**:

Press ``?`` in FZF to toggle preview on.

**Search results incomplete**:

Check ``.gitignore`` - FZF respects ignored files. Use ``<C-f>`` (all files) to override.

See :doc:`troubleshooting` for more help.

Keyboard Shortcuts Summary
==========================

+-------------------+-------------------------------------------+
| Key               | Action                                    |
+===================+===========================================+
| ``<C-f>``         | Find files                                |
+-------------------+-------------------------------------------+
| ``<C-b>``         | Switch buffers                            |
+-------------------+-------------------------------------------+
| ``<C-g>``         | Search git files                          |
+-------------------+-------------------------------------------+
| ``<leader>r``     | Search file contents                      |
+-------------------+-------------------------------------------+
| ``<leader>s``     | Search in selection                       |
+-------------------+-------------------------------------------+

In FZF menu:

+-------------------+-------------------------------------------+
| ``Enter``         | Open in current window                    |
+-------------------+-------------------------------------------+
| ``<C-x>``         | Open in horizontal split                  |
+-------------------+-------------------------------------------+
| ``<C-v>``         | Open in vertical split                    |
+-------------------+-------------------------------------------+
| ``<C-t>``         | Open in new tab                           |
+-------------------+-------------------------------------------+
