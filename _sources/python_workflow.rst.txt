================
Python Workflow
================

This configuration is optimized for Python development. This guide covers common development tasks.

Running Tests
=============

Run all tests in the current file:

.. code-block:: vim

    <leader>t

The output appears in a floating terminal. Use ``q`` to close it.

Run a specific test function:

.. code-block:: vim

    <leader>T

This opens a dialog where you can select which test to run.

**Example**:

If you have a file ``test_utils.py`` with tests:

.. code-block:: python

    def test_add():
        assert add(1, 2) == 3

    def test_subtract():
        assert subtract(5, 3) == 2

Press ``<leader>t`` to run both tests, or ``<leader>T`` to run one specific test.

Code Formatting
===============

Format your current Python file with darker:

.. code-block:: vim

    <leader>f

Darker applies the following:

- **Black formatting** - Reformats your code
- **isort integration** - Organizes imports
- **Line length** - Preserved at 140 characters
- **Diff mode** - Only formats changed lines (doesn't reformat entire file)

**Configuration**:

Edit ``pyproject.toml`` to customize:

.. code-block:: toml

    [tool.darker]
    line_length = 140

    [tool.isort]
    profile = "black"
    multi_line_mode = 3

Code Navigation
===============

**Go to definition**:

.. code-block:: vim

    gd

**Go to declaration**:

.. code-block:: vim

    gD

**Find all references**:

.. code-block:: vim

    gr

**Find implementations**:

.. code-block:: vim

    gi

**Show documentation** (hover info):

.. code-block:: vim

    K

Code Completion
===============

The LSP provides code completion. In insert mode:

.. code-block:: vim

    <C-x><C-o>

Or use a completion plugin like ``nvim-cmp`` for more automatic completion.

The LSP provides:

- Function/class suggestions
- Parameter hints
- Documentation
- Type information

Refactoring
===========

**Rename symbol**:

.. code-block:: vim

    <leader>rn

This renames all occurrences of the symbol across the project.

**Example**:

.. code-block:: python

    def old_function_name():
        pass

Position cursor on ``old_function_name``, press ``<leader>rn``, and type the new name. All references update automatically.

Searching and Replacing
========================

**Find in project**:

.. code-block:: vim

    <leader>r

Type to search file contents across the project.

**Find and replace** (standard Vim):

.. code-block:: vim

    :%s/old_text/new_text/g

Use ``%`` for entire file, or ``:10,20s/old/new/g`` for a specific range.

**Example**: Replace all instances of ``print`` with ``logger.info``:

.. code-block:: vim

    :%s/print(/logger.info(/g

Linting
=======

Ruff is integrated for linting. Issues appear as inline diagnostics.

**View diagnostics**:

.. code-block:: vim

    <leader>d

Toggle diagnostics display on and off.

**Go to next diagnostic**:

.. code-block:: vim

    ]d

**Go to previous diagnostic**:

.. code-block:: vim

    [d

Ruff checks for:

- Syntax errors
- Undefined names
- Unused imports
- PEP 8 style issues
- And more (configurable)

Working with Multiple Files
============================

**Open file side-by-side**:

1. Find file with ``<C-f>``
2. Press ``<C-v>`` to open in vertical split
3. Or press ``<C-x>`` for horizontal split

**Switch between splits**:

.. code-block:: vim

    <C-h><C-j><C-k><C-l>

Navigate between panes (left, down, up, right).

**Close split**:

.. code-block:: vim

    :q

Debugging Workflow
==================

While Neovim doesn't have a built-in debugger, you can:

1. **Use print debugging**:

   .. code-block:: python

       print(f"Debug: {variable}")

2. **Run tests** with ``<leader>t`` to catch errors
3. **Use :! to run commands**:

   .. code-block:: vim

       :!python -m pdb my_script.py

4. **Check diagnostics** with ``<leader>d`` to see errors

Virtual Environment
===================

The configuration automatically uses the Python virtual environment at ``~/.virtualenvs/nvim``.

To verify it's being used:

.. code-block:: vim

    :checkhealth python

To use a different virtual environment:

Edit ``lua/lsp/lsp.lua`` and change the Python executable path.

Working with Git
================

**Search git files**:

.. code-block:: vim

    <C-g>

**View git status** (in terminal):

.. code-block:: bash

    git status

**Stage changes**:

.. code-block:: bash

    git add file.py

**Commit**:

.. code-block:: bash

    git commit -m "Description of changes"

Common Development Patterns
===========================

**Pattern 1: Write test, then implementation**

1. Open test file: ``<C-f>`` find ``test_*.py``
2. Write test function
3. Run test: ``<leader>t`` (will fail)
4. Open implementation file: ``<C-f>`` find the module
5. Write code to make test pass
6. Run test again: ``<leader>t`` (should pass)

**Pattern 2: Quick test and format cycle**

1. Make changes
2. Format: ``<leader>f``
3. Run tests: ``<leader>t``
4. Check diagnostics: ``<leader>d``
5. Commit changes

**Pattern 3: Refactoring with safety**

1. Find all references: ``gr``
2. Use rename: ``<leader>rn`` to update all at once
3. Run tests: ``<leader>t`` to verify
4. Format: ``<leader>f`` before committing

Tips and Tricks
===============

**Quickly jump to test file**:

If editing ``my_module.py``, jump to ``test_my_module.py`` with your file finder.

**Use line numbers for navigation**:

.. code-block:: vim

    :123  " Jump to line 123

**See coverage for current function**:

.. code-block:: vim

    <leader>c

**Run tests in watch mode** (outside Neovim):

.. code-block:: bash

    pytest-watch my_module.py

This automatically reruns tests when you save files.

**Profile your code** (outside Neovim):

.. code-block:: bash

    python -m cProfile -s cumulative my_script.py

Then look at the output to see bottlenecks.

Performance Tips
================

- Use FZF (``<C-f>``) instead of file browser - it's much faster
- Use ``gr`` to find references instead of manual search
- LSP provides instant navigation without searching
- Format with ``<leader>f`` regularly to catch issues early
- Run tests frequently with ``<leader>t`` to catch bugs early

See :doc:`troubleshooting` if you encounter issues during development.
