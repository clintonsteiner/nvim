===============
Troubleshooting
===============

Solutions to common problems.

General Diagnostics
===================

Always start with:

.. code-block:: vim

    :checkhealth

This shows the status of all major components.

**Check messages**:

.. code-block:: vim

    :messages

Shows any warnings or errors.

**View logs**:

.. code-block:: bash

    # Neovim logs
    tail -f ~/.local/share/nvim/nvim.log

    # LSP logs
    tail -f ~/.local/share/nvim/lsp.log

Installation Issues
===================

**Error: Python not found**

.. code-block:: text

    Problem: python3: command not found

Solution: Install Python:

.. code-block:: bash

    # macOS
    brew install python@3.11

    # Linux (Debian/Ubuntu)
    sudo apt-get install python3

**Error: Git clone fails**

.. code-block:: text

    Problem: fatal: unable to access repository

Possible causes:

1. Internet connection issue - check connectivity
2. Wrong URL - verify repository URL
3. Git not installed - install Git

**Error: Permission denied**

.. code-block:: text

    Problem: /Users/cs/.config/nvim: Permission denied

Solution: Fix permissions:

.. code-block:: bash

    chmod -R 755 ~/.config/nvim
    chmod -R 755 ~/.virtualenvs/nvim

**Error: No space left on device**

Check disk space:

.. code-block:: bash

    df -h

Free up space and retry installation.

Neovim Not Found
================

**Error: nvim: command not found**

Cause: Neovim not installed or not in PATH.

**Fix for Homebrew installation**:

.. code-block:: bash

    brew install neovim

**Fix for binary installation**:

1. Verify binary exists:

   .. code-block:: bash

       ls -la ~/apps/neovim/nvim.app/bin/nvim  # macOS
       ls -la ~/apps/neovim/nvim.appimage       # Linux

2. Add to PATH:

   .. code-block:: bash

       export PATH=$HOME/apps/neovim/nvim.app/bin:$PATH

3. Add to shell profile (``~/.bashrc`` or ``~/.zshrc``):

   .. code-block:: bash

       export PATH=$HOME/.local/bin:$PATH

**Verify installation**:

.. code-block:: bash

    which nvim
    nvim --version

Python Virtual Environment Issues
===================================

**Error: Virtual environment not found**

Solution: Create it manually:

.. code-block:: bash

    python3 -m venv ~/.virtualenvs/nvim
    source ~/.virtualenvs/nvim/bin/activate
    pip install pynvim zuban ruff "darker[isort]"
    deactivate

**Error: ModuleNotFoundError: No module named 'pynvim'**

Solution: Install missing package:

.. code-block:: bash

    ~/.virtualenvs/nvim/bin/pip install pynvim

**Error: Python version mismatch**

Neovim uses the Python from ``~/.virtualenvs/nvim/``. To check:

.. code-block:: bash

    ~/.virtualenvs/nvim/bin/python --version

**Wrong Python being used**:

Configure which Python in ``lua/lsp/lsp.lua``:

.. code-block:: lua

    settings = {
        python = {
            pythonPath = os.getenv('HOME') .. '/.virtualenvs/nvim/bin/python',
        }
    }

LSP Not Working
===============

**Error: LSP not activating**

1. Check Python path:

   .. code-block:: vim

       :checkhealth python

2. Verify Zuban installed:

   .. code-block:: bash

       ~/.virtualenvs/nvim/bin/python -m pip list | grep zuban

3. If missing, install it:

   .. code-block:: bash

       ~/.virtualenvs/nvim/bin/pip install zuban

4. Restart Neovim

**Error: Go to definition not working**

Possible causes:

1. LSP still analyzing - wait a moment
2. Symbol is built-in (may not work for builtins)
3. LSP not active - check with ``:LspInfo``

Try:

.. code-block:: vim

    :LspRestart

**Error: Code completion not showing**

1. Ensure you're in insert mode
2. Press ``<C-x><C-o>`` explicitly
3. Check `:LspInfo` for errors
4. Try: ``:LspRestart``

**Error: Too many diagnostic errors**

Diagnostics may be overly aggressive. Configure in ``lua/lsp/lsp.lua``:

.. code-block:: lua

    analysis = {
        typeCheckingMode = "basic",  -- Use "off" to disable
    }

**Error: LSP too slow**

1. Close large files (LSP struggles with huge files)
2. Configure to skip large files:

   .. code-block:: lua

       function on_attach(client, bufnr)
           if vim.fn.getfsize(vim.fn.bufname(bufnr)) > 1000000 then
               client.stop()  -- Don't analyze files > 1MB
           end
       end

3. Reduce diagnostic checking
4. Try: ``:LspRestart``

FZF Not Working
===============

**Error: FZF not found**

Install FZF:

.. code-block:: bash

    # macOS
    brew install fzf

    # Linux
    sudo apt-get install fzf

**Error: Ripgrep not found** (used by FZF)

Install Ripgrep:

.. code-block:: bash

    # macOS
    brew install ripgrep

    # Linux
    sudo apt-get install ripgrep

**Commands not responding**:

1. Verify FZF installed: ``fzf --version``
2. Verify Ripgrep installed: ``rg --version``
3. Restart Neovim
4. Check if directory is huge (too many files)

**Slow searches**:

Large directories slow FZF. Use:

- ``<C-g>`` (git files) instead of ``<C-f>`` (all files)
- Add exclusions in ``lua/plugin/fzf-lua.lua``

**Missing search results**:

Files may be in ``.gitignore``. To search all files:

.. code-block:: vim

    <C-f>  " All files, not just git-tracked

Keybinding Issues
=================

**Error: Keybinding not working**

1. Check it's mapped correctly:

   .. code-block:: vim

       :map <leader>x  " Shows what's mapped to <leader>x

2. Check for typos in ``lua/plugin/which-key.lua``
3. Verify syntax is correct
4. Restart Neovim

**Error: which-key menu not showing**

1. Check which-key is installed:

   .. code-block:: vim

       :checkhealth

2. If not installed, reinstall plugins:

   .. code-block:: vim

       :PlugInstall

3. Verify which-key is required in ``init.lua``
4. Restart Neovim

**Error: Keybinding conflicts**

If a keybinding does something unexpected:

1. View all keybindings:

   .. code-block:: vim

       :map  " All mappings
       :map <leader>  " Leader key mappings

2. Find conflicting binding
3. Comment out or change it in ``lua/plugin/which-key.lua``
4. Restart Neovim

Syntax Highlighting Issues
==========================

**Error: Treesitter parsers missing**

Install parsers:

.. code-block:: vim

    :TSInstall python lua comment vim vimdoc c sql query

**Error: Colors look wrong**

1. Check colorscheme:

   .. code-block:: vim

       :colorscheme  " Shows current scheme

2. Verify terminal supports colors:

   .. code-block:: bash

       echo $TERM
       # Should be: xterm-256color or similar

3. Ensure Nerd Font is installed:

   - See :doc:`requirements` for Nerd Font setup

**Error: Icons not displaying**

1. Install a Nerd Font (see :doc:`requirements`)
2. Set as terminal font in settings
3. Restart terminal and Neovim

Performance Issues
==================

**Slow startup**:

Profile to find bottleneck:

.. code-block:: bash

    nvim --startuptime startup.log +q
    sort -k2 -n startup.log | tail -20

Common culprits:

- Heavy plugins
- Large config files
- Disk I/O issues
- Too many language servers

**Slow editing**:

1. Close unused buffers: ``:bd``
2. Disable expensive features:

   .. code-block:: vim

       :set updatetime=500  " Increase LSP check interval

3. Close very large files
4. Check disk space

**High CPU usage**:

1. Check which plugin:

   .. code-block:: vim

       :profile start profile.log
       :profile func *
       " ... do something slow ...
       :profile pause
       " Check profile.log

2. Disable that plugin or configure it
3. Restart Neovim

Configuration Errors
====================

**Error: Lua syntax error**

Check the error:

.. code-block:: vim

    :checkhealth
    :messages

Likely causes:

- Missing comma in table
- Unclosed parenthesis
- Wrong function name
- Missing quotes

**Error: File not found**

When loading configuration:

.. code-block:: text

    Error: No such file or directory: lua/plugin/missing.lua

Solution: Create the missing file or remove the require statement.

**Error: Undefined variable**

.. code-block:: text

    Error: undefined global 'some_variable'

Solution: Define the variable or check the name.

File Permissions
================

**Error: Permission denied**

.. code-block:: bash

    chmod -R 755 ~/.config/nvim
    chmod -R 755 ~/.dotfiles/nvim

**Cannot create file**:

Check directory permissions:

.. code-block:: bash

    ls -la ~/.config/

Neovim Crashes
==============

**Crash when opening file**:

1. Note which file causes crash
2. Try disabling plugins one by one
3. Check logs: ``tail -f ~/.local/share/nvim/nvim.log``
4. Report issue with file and plugin info

**Crash on startup**:

1. Check ``:checkhealth`` for errors
2. Try starting with minimal config:

   .. code-block:: bash

       nvim -u NONE

3. If works, find problematic plugin
4. Check for corrupted config files

**Crash with specific command**:

1. Note which command
2. Try in safe mode: ``nvim -u NONE -i NONE``
3. Report with exact reproduction steps

Terminal-Related Issues
=======================

**Error: Colors not working in terminal**

Check terminal color support:

.. code-block:: bash

    echo $TERM
    # Should show: xterm-256color, screen-256color, tmux, etc.

If not 256 colors:

.. code-block:: bash

    export TERM=xterm-256color

Add to ``~/.bashrc`` or ``~/.zshrc`` to make permanent.

**Error: Scrolling issues**

In Neovim:

.. code-block:: vim

    set mouse=a  " Enable mouse

Or in configuration:

.. code-block:: lua

    vim.opt.mouse = "a"

**Error: Clipboard not working**

Requires system clipboard support:

.. code-block:: bash

    brew install reattach-to-user-namespace  # macOS
    sudo apt-get install xclip               # Linux

Verify in Neovim:

.. code-block:: vim

    :checkhealth clipboard

Git-Related Issues
==================

**Error: Git hooks failing**

If a hook blocks commits:

1. Edit ``.git/hooks/`` to see what's running
2. Or bypass with: ``git commit --no-verify``
3. Fix the issue that triggered the hook

**Error: Not a git repository**

Neovim features (like gitsigns) need git repo:

.. code-block:: bash

    git init

Or clone the repo in a git project.

Getting Help
============

If you can't solve the issue:

1. **Run diagnostics**:

   .. code-block:: vim

       :checkhealth
       :messages

2. **Check logs**:

   .. code-block:: bash

       tail -50 ~/.local/share/nvim/nvim.log

3. **Search issues**:

   - Check GitHub issues for similar problems
   - Search troubleshooting guide

4. **Report issue**:

   - Include ``:checkhealth`` output
   - Include error messages and logs
   - Include Neovim version: ``nvim --version``
   - Include minimal reproduction steps

5. **Ask community**:

   - Neovim forums
   - Discord/Slack communities
   - GitHub discussions

Common Messages
===============

**Message: "Syntax error in"**

- Check Lua file syntax
- Look for missing commas, quotes, parentheses
- Check line numbers in error

**Message: "Unknown option"**

- Check option name spelling
- Verify option exists in your Neovim version
- Check ``:help`` for correct syntax

**Message: "Plugin failed to load"**

- Plugin may not be installed
- Check for typos in require statement
- Verify dependencies are met
- Restart Neovim

Quick Fixes Summary
===================

Most common quick fixes:

1. **Restart Neovim** - Solves 30% of issues
2. **Run ``:checkhealth``** - Diagnoses most issues
3. **Reinstall plugins** - ``:PlugClean`` then ``:PlugInstall``
4. **Check virtual environment** - Python issues often here
5. **View error messages** - ``:messages`` shows what's wrong
6. **Check installation** - Run ``python3 install.py`` again

If none of these work, see the detailed sections above or :doc:`development` for how to debug further.
