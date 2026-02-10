===========
Keybindings
===========

The leader key is ``<Space>`` by default. All keybindings are organized using **which-key**, which shows a popup menu when you press the leader key.

Press ``<Space>`` and wait to see all available commands.

Core Navigation
===============

+-------------------+-------------------------------------------+
| Key               | Action                                    |
+===================+===========================================+
| ``<C-f>``         | Find files by name                        |
+-------------------+-------------------------------------------+
| ``<C-b>``         | Switch between open buffers               |
+-------------------+-------------------------------------------+
| ``<C-g>``         | Search in git files                       |
+-------------------+-------------------------------------------+
| ``<leader>r``     | Search file contents in project           |
+-------------------+-------------------------------------------+
| ``<leader>s``     | Search in current selection               |
+-------------------+-------------------------------------------+
| ``gd``            | Go to definition                          |
+-------------------+-------------------------------------------+
| ``gD``            | Go to declaration                         |
+-------------------+-------------------------------------------+
| ``gr``            | Find all references                       |
+-------------------+-------------------------------------------+
| ``gi``            | Find implementations                      |
+-------------------+-------------------------------------------+
| ``K``             | Show documentation/hover info             |
+-------------------+-------------------------------------------+
| ``<C-k>``         | Show signature help (for functions)       |
+-------------------+-------------------------------------------+

Python Development
==================

+-------------------+-------------------------------------------+
| Key               | Action                                    |
+===================+===========================================+
| ``<leader>t``     | Run pytest on current file                |
+-------------------+-------------------------------------------+
| ``<leader>T``     | Run specific test function                |
+-------------------+-------------------------------------------+
| ``<leader>c``     | Generate coverage report for module       |
+-------------------+-------------------------------------------+
| ``<leader>f``     | Format file with darker                   |
+-------------------+-------------------------------------------+
| ``<leader>rn``    | Rename symbol (refactoring)               |
+-------------------+-------------------------------------------+

Text Manipulation
=================

+-------------------+-------------------------------------------+
| Key               | Action                                    |
+===================+===========================================+
| ``<leader>w``     | Toggle line wrapping                      |
+-------------------+-------------------------------------------+
| ``<leader>d``     | Toggle diagnostics display                |
+-------------------+-------------------------------------------+
| ``<leader>ss``    | Save current session                      |
+-------------------+-------------------------------------------+
| ``<leader>sl``    | Load saved session                        |
+-------------------+-------------------------------------------+

Standard Vim Bindings
=====================

This configuration preserves standard Vim bindings:

Navigation
----------

+-------------------+-------------------------------------------+
| Key               | Action                                    |
+===================+===========================================+
| ``h/j/k/l``       | Move cursor left/down/up/right            |
+-------------------+-------------------------------------------+
| ``w/b``           | Move to next/previous word                |
+-------------------+-------------------------------------------+
| ``gg``            | Go to beginning of file                   |
+-------------------+-------------------------------------------+
| ``G``             | Go to end of file                         |
+-------------------+-------------------------------------------+
| ``/``             | Search forward in file                    |
+-------------------+-------------------------------------------+
| ``?``             | Search backward in file                   |
+-------------------+-------------------------------------------+
| ``n/N``           | Go to next/previous search result         |
+-------------------+-------------------------------------------+

Editing
-------

+-------------------+-------------------------------------------+
| Key               | Action                                    |
+===================+===========================================+
| ``i/a/o``         | Insert/append/new line (enter insert)     |
+-------------------+-------------------------------------------+
| ``d``             | Delete (motion following)                 |
+-------------------+-------------------------------------------+
| ``y``             | Yank (copy)                               |
+-------------------+-------------------------------------------+
| ``p/P``           | Paste after/before cursor                 |
+-------------------+-------------------------------------------+
| ``u``             | Undo                                      |
+-------------------+-------------------------------------------+
| ``<C-r>``         | Redo                                      |
+-------------------+-------------------------------------------+
| ``>>/<<``         | Indent/unindent line                      |
+-------------------+-------------------------------------------+

Example: ``dw`` deletes a word, ``dd`` deletes entire line, ``yy`` copies a line

Customizing Keybindings
=======================

All keybindings are defined in ``lua/plugin/which-key.lua``. To customize:

1. Open the file:

   .. code-block:: bash

       nvim lua/plugin/which-key.lua

2. Find the keybinding you want to change
3. Edit the table to add or modify bindings
4. Save and reload Neovim (or restart)

Example: Adding a new keybinding

.. code-block:: lua

    -- In lua/plugin/which-key.lua
    local wk = require("which-key")

    wk.add({
      { "<leader>x", "<cmd>MyCommand<cr>", desc = "Description of my command" }
    })

FZF-specific Bindings
=====================

When in FZF (fuzzy finder), use:

+-------------------+-------------------------------------------+
| Key               | Action                                    |
+===================+===========================================+
| ``<C-j>/<C-k>``   | Move down/up through results              |
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

Quick Reference Card
====================

Save this quick reference:

.. code-block:: text

    NAVIGATION
    <C-f>    Find files        <leader>r    Search content
    <C-b>    Buffers           gd           Goto definition
    <C-g>    Git files         gr           References

    PYTHON DEV
    <leader>t    Run tests      <leader>f    Format code
    <leader>T    Single test    <leader>c    Coverage

    EDITING
    dw       Delete word       yy           Copy line
    <leader>d    Toggle diags   <leader>w    Toggle wrap

    CORE VIM
    u        Undo              <C-r>        Redo
    /        Search            n/N          Next/prev match

Tips
====

1. **Use which-key discovery** - Press ``<leader>`` and wait to see all options
2. **Learn incrementally** - Focus on a few bindings at a time
3. **Use vim motions** - Combine keys (e.g., ``d5w`` deletes 5 words)
4. **Check with :map** - Run ``:map`` in Neovim to see all mappings
5. **Customize for your workflow** - Add bindings for commands you use often

See :doc:`customization` for how to add your own keybindings.
