===========
Development
===========

Information for developers who want to modify or extend this configuration.

Prerequisites for Development
==============================

To work on the configuration, you need:

1. Neovim installed
2. Git for version control
3. Python for the installer
4. Lua for configuration files

**Optional**:

- Node.js for some language servers
- Cargo for Rust tools
- Docker for isolated testing

Development Workflow
====================

1. **Clone the repository**:

   .. code-block:: bash

       git clone https://github.com/clintonsteiner/nvim.git ~/dotfiles/nvim
       cd ~/dotfiles/nvim

2. **Create a branch for your changes**:

   .. code-block:: bash

       git checkout -b feature/my-feature

3. **Make changes** to configuration files

4. **Test your changes**:

   .. code-block:: bash

       nvim  # Launch Neovim
       :checkhealth  # Verify setup

5. **Commit changes**:

   .. code-block:: bash

       git add .
       git commit -m "Description of changes"

6. **Push and create a PR** (if contributing):

   .. code-block:: bash

       git push origin feature/my-feature

Testing Configuration Changes
=============================

After modifying Lua files:

1. **Reload configuration**:

   .. code-block:: vim

       :luafile %  " Reload current file
       :source %   " Source Vim config

2. **Or restart Neovim**:

   .. code-block:: bash

       nvim

3. **Check for errors**:

   .. code-block:: vim

       :checkhealth
       :messages

4. **Test affected features**:

   - If you modified LSP: Open a Python file, check diagnostics
   - If you modified keybindings: Press ``<leader>`` to see menu
   - If you modified FZF: Try ``<C-f>`` to find files

Adding New Features
===================

**Example: Add a new keybinding for a custom command**

1. Create the command:

   .. code-block:: lua

       -- In lua/utils/my_commands.lua
       function MyCommand()
           vim.notify("My command executed!")
       end

2. Add keybinding:

   .. code-block:: lua

       -- In lua/plugin/which-key.lua
       wk.add({
           { "<leader>mc", function() MyCommand() end, desc = "My command" }
       })

3. Test:

   .. code-block:: bash

       nvim
       # Press <leader>mc to test

**Example: Add support for a new language**

1. Create LSP config:

   .. code-block:: lua

       -- In lua/lsp/lsp.lua
       lsp.gopls.setup({
           capabilities = capabilities,
           on_attach = on_attach,
       })

2. Test:

   .. code-block:: bash

       nvim test.go
       # Should have LSP features for Go

Extending Lua Configuration
=============================

**File organization**:

.. code-block:: text

    lua/
    ├── plugin/       # Plugin configurations
    ├── lsp/          # LSP setup
    └── utils/        # Utility functions

**Best practices**:

1. Keep files focused (one concern per file)
2. Use clear names (``my_feature.lua``, not ``m.lua``)
3. Document non-obvious code
4. Follow existing patterns
5. Test before committing

**Example utility function**:

.. code-block:: lua

    -- In lua/utils/my_utils.lua
    local M = {}

    --- Description of function
    -- @param arg1 string
    -- @return string
    function M.my_function(arg1)
        return "Result: " .. arg1
    end

    return M

Modifying the Installer
=======================

The installer is in ``install.py``. To modify it:

1. Edit the file
2. Test it:

   .. code-block:: bash

       python3 install.py

3. Verify each step works correctly
4. Commit changes

**Common modifications**:

- Change installation paths
- Add new dependencies
- Modify setup steps
- Add new tools

Always test the installer thoroughly before committing!

Documentation
=============

Documentation is in ``docs/source/``. It uses Sphinx and reStructuredText.

**To build documentation**:

.. code-block:: bash

    cd docs
    make html

Output is in ``docs/_build/html/``.

**To add new documentation**:

1. Create ``.rst`` file in ``docs/source/``
2. Add to ``index.rst``
3. Build and verify

**RST syntax tips**:

.. code-block:: rst

    # Headers
    ============
    Main Header
    ============

    Section
    -------

    Subsection
    ^^^^^^^^^^

    # Code blocks
    .. code-block:: python

        print("Hello")

    # Lists
    - Item 1
    - Item 2

    # Links
    `Link text <https://example.com>`_

Version Control
===============

**Commit message format**:

.. code-block:: text

    Short description (under 50 chars)

    Longer explanation of what and why.
    Can span multiple lines.

**Example**:

.. code-block:: bash

    git commit -m "Add LSP support for Go"

**Branch naming**:

- ``feature/description`` - New features
- ``fix/description`` - Bug fixes
- ``docs/description`` - Documentation
- ``refactor/description`` - Code cleanup

**Workflow**:

.. code-block:: bash

    # 1. Create branch
    git checkout -b feature/my-feature

    # 2. Make changes
    # ... edit files ...

    # 3. Stage changes
    git add .

    # 4. Commit
    git commit -m "Description"

    # 5. Push
    git push origin feature/my-feature

    # 6. Create PR (optional)
    # (on GitHub)

Debugging Lua Configuration
===========================

**Print debugging**:

.. code-block:: lua

    print("Variable: " .. tostring(variable))
    vim.notify("Notification message")

**View in editor**:

.. code-block:: vim

    :messages  " See all notifications

**Check configuration**:

.. code-block:: vim

    :set<space>  " Show current settings
    :map<space>  " Show keybindings
    :scriptnames " Show loaded scripts

**Profile performance**:

.. code-block:: bash

    nvim --startuptime profile.log +q
    # Check profile.log

Testing Guidelines
==================

Before committing:

1. **Syntax check**: No Lua errors
2. **Feature test**: Your changes work
3. **Integration test**: Other features still work
4. **Performance**: No significant slowdown

**Test checklist**:

.. code-block:: text

    - [ ] No errors in :checkhealth
    - [ ] :messages is clear
    - [ ] Key features work (LSP, FZF, etc.)
    - [ ] Startup time acceptable
    - [ ] No regressions

Code Style
==========

**Lua style guide**:

- Use 4 spaces for indentation
- Use clear variable names
- Comment complex logic
- Keep functions focused
- Use local variables

**Example**:

.. code-block:: lua

    -- Good
    local function setup_lsp()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        -- ...
    end

    -- Bad
    function s()
        c = vc()
        -- ...
    end

Performance Considerations
==========================

**Startup time**:

.. code-block:: bash

    # Measure
    nvim --startuptime log.txt +q

    # Look for slow plugins/files
    sort -k2 -n log.txt | tail -20

**Tips**:

- Lazy load plugins when possible
- Avoid heavy computations in config
- Use local variables (faster than globals)
- Cache computed values

**Optimizing plugins**:

If a plugin is slow:

1. Check if it's lazy-loadable
2. Reduce its configuration
3. Consider alternatives
4. Or disable it if rarely used

Contributing
============

If you want to contribute:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Write tests
5. Update documentation
6. Create a pull request

**Before submitting a PR**:

- [ ] Tests pass
- [ ] Documentation updated
- [ ] No breaking changes
- [ ] Commit messages are clear
- [ ] Code follows style guide

**PR template**:

.. code-block:: markdown

    ## Description
    What does this PR do?

    ## Changes
    - Change 1
    - Change 2

    ## Testing
    How to test?

    ## Breaking Changes
    Any backwards incompatible changes?

Setting Up Development Environment
===================================

**Install development tools**:

.. code-block:: bash

    # macOS
    brew install neovim python@3.11 git

    # Linux
    sudo apt-get install neovim python3 git

**Clone repository**:

.. code-block:: bash

    git clone https://github.com/clintonsteiner/nvim.git ~/dev/nvim
    cd ~/dev/nvim

**Create virtual environment**:

.. code-block:: bash

    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements-dev.txt

**Run tests** (if tests exist):

.. code-block:: bash

    pytest

Useful Resources
================

- `Neovim documentation <https://neovim.io/doc/>`_
- `Lua documentation <https://www.lua.org/manual/>`_
- `Vim commands <https://vimdoc.sourceforge.io/>`_
- `LSP specification <https://microsoft.github.io/language-server-protocol/>`_

Troubleshooting Development
===========================

**Configuration won't load**:

1. Check syntax: ``:checkhealth``
2. View errors: ``:messages``
3. Check file permissions: ``ls -la lua/``

**Tests failing**:

1. Check test output for details
2. Run individual tests
3. Check dependencies

**Git issues**:

.. code-block:: bash

    # View status
    git status

    # View changes
    git diff

    # Reset changes
    git checkout .

    # View history
    git log --oneline -10

Need Help?
==========

- Check :doc:`troubleshooting` guide
- Review existing issues on GitHub
- Consult Neovim documentation
- Ask in Neovim community forums
