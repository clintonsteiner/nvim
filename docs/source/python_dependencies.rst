====================
Python Dependencies
====================

Reference documentation for Python packages used in the configuration.

Overview
========

The configuration requires a Python virtual environment (``~/.virtualenvs/nvim``) with specific packages installed.

The ``install.py`` script handles this automatically, but you can also install manually.

List of Dependencies
====================

+-------------------+--------+-------------------------------------------------------------+
| Package           | Version| Purpose                                                     |
+===================+========+=============================================================+
| pynvim            | >=0.4.3| Python bindings for Neovim API                            |
+-------------------+--------+-------------------------------------------------------------+
| zuban             | >=0.2.0| Python Language Server (LSP) for code intelligence        |
+-------------------+--------+-------------------------------------------------------------+
| ruff              | >=0.1.0| Fast Python linter for code quality                       |
+-------------------+--------+-------------------------------------------------------------+
| darker[isort]     | >=1.7.0| Code formatter with import sorting                        |
+-------------------+--------+-------------------------------------------------------------+

Package Details
===============

pynvim
------

**What it does**: Provides Python bindings for Neovim's msgpack API.

**Why needed**: Neovim plugins written in Python need this to communicate with the editor.

**Installation**:

.. code-block:: bash

    ~/.virtualenvs/nvim/bin/pip install pynvim>=0.4.3

**Features**:

- Execute Neovim commands from Python
- Access Neovim buffers and windows
- Write Neovim plugins in Python
- RPC communication with Neovim

**Version requirement**: 0.4.3+ supports Neovim 0.5+

**Documentation**: `pynvim GitHub <https://github.com/neovim/pynvim>`_

Zuban
-----

**What it does**: Python Language Server providing intelligent code analysis.

**Why needed**: Enables LSP features:

- Code completion
- Go to definition
- Find references
- Hover information
- Diagnostics (errors/warnings)
- Rename refactoring

**Installation**:

.. code-block:: bash

    ~/.virtualenvs/nvim/bin/pip install zuban>=0.2.0

**Zuban features**:

- Written in Rust (very fast)
- Type checking
- Comprehensive Python support
- Supports Python 3.8+
- Active development

**Configuration**: Configured in ``lua/lsp/lsp.lua``

**Example settings**:

.. code-block:: lua

    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",
            }
        }
    }

**Documentation**: `Zuban GitHub <https://github.com/zubanls/zuban>`_

**Alternative servers** (if you want different ones):

- Pylance (Microsoft, VS Code focused)
- Pyright (similar to Pylance)
- Jedi (simple, good for basic tasks)

To use a different server, edit ``lua/lsp/lsp.lua`` and change the server configuration.

Ruff
----

**What it does**: Fast, modern Python linter checking code quality.

**Why needed**: Catches common errors and style issues:

- Undefined variables
- Unused imports
- Style violations (PEP 8)
- Complexity issues
- And hundreds more rules

**Installation**:

.. code-block:: bash

    ~/.virtualenvs/nvim/bin/pip install ruff>=0.1.0

**Features**:

- Extremely fast (written in Rust)
- Minimal configuration
- Compatible with Black formatter
- Thousands of rules
- Extensible

**Configuration** in ``pyproject.toml``:

.. code-block:: toml

    [tool.ruff]
    line-length = 100
    select = ["E", "W", "F", "I"]  # What rules to enable
    ignore = ["E501"]              # What to ignore

**Rules**:

- E: PEP 8 errors
- W: PEP 8 warnings
- F: PyFlakes (logic errors)
- I: isort (import sorting)

**Documentation**: `Ruff GitHub <https://github.com/astral-sh/ruff>`_

Darker
------

**What it does**: Code formatter that applies Black formatting to only changed lines.

**Why needed**: Keeps code style consistent while minimizing git diffs:

- Formats Python code
- Uses Black formatting
- Integrates isort for imports
- Only touches changed lines
- Respects line length

**Installation**:

.. code-block:: bash

    ~/.virtualenvs/nvim/bin/pip install "darker[isort]>=1.7.0"

Note the ``[isort]`` extra - this includes isort integration.

**Features**:

- Diff-aware (only changes what changed)
- Black-compatible
- isort integration for imports
- Respects git history
- Preserves unchanged code

**Configuration** in ``pyproject.toml``:

.. code-block:: toml

    [tool.darker]
    line_length = 140

    [tool.isort]
    profile = "black"
    multi_line_mode = 3

**Line length**: Set to 140 by default (configurable)

**Keybinding**: ``<leader>f`` to format current file

**Why darker vs black?**

- Black reformats entire file (more disruptive)
- Darker only reformats changed lines (cleaner diffs)
- Perfect for gradual formatting adoption
- Better for team settings where code style is evolving

**Documentation**: `Darker GitHub <https://github.com/akaihola/darker>`_

Installing Dependencies
=======================

**Automatic** (recommended):

.. code-block:: bash

    python3 install.py

The script handles everything.

**Manual installation**:

.. code-block:: bash

    # Create virtual environment
    python3 -m venv ~/.virtualenvs/nvim

    # Activate it
    source ~/.virtualenvs/nvim/bin/activate

    # Install packages
    pip install pynvim zuban ruff "darker[isort]"

    # Deactivate
    deactivate

**Using uv** (faster):

.. code-block:: bash

    # Install uv first
    pip install uv

    # Create venv
    uv venv ~/.virtualenvs/nvim

    # Install packages
    uv pip install pynvim zuban ruff "darker[isort]"

Updating Dependencies
=====================

**Update all**:

.. code-block:: bash

    ~/.virtualenvs/nvim/bin/pip install --upgrade pynvim zuban ruff darker

**Update specific package**:

.. code-block:: bash

    ~/.virtualenvs/nvim/bin/pip install --upgrade zuban

**Check for updates**:

.. code-block:: bash

    ~/.virtualenvs/nvim/bin/pip list --outdated

**Update via pyproject.toml**:

Edit versions in ``pyproject.toml``:

.. code-block:: toml

    [project]
    dependencies = [
        "pynvim>=0.5.0",  # New version
        "zuban>=0.3.0",   # New version
    ]

Then reinstall:

.. code-block:: bash

    ~/.virtualenvs/nvim/bin/pip install --upgrade -e .

Verifying Installation
======================

**Check what's installed**:

.. code-block:: bash

    ~/.virtualenvs/nvim/bin/pip list

Should show:

.. code-block:: text

    Package    Version
    ---------- -------
    pynvim     0.4.3
    zuban      0.2.5
    ruff       0.1.8
    darker      1.7.2
    isort      5.12.0

**Verify Neovim can use them**:

.. code-block:: vim

    :checkhealth python

Should show green checkmarks for:

- Python provider
- Python3 executable path
- Packages found

**Test LSP**:

.. code-block:: bash

    # Create test file
    echo 'undefined_variable' > test.py

    # Open in Neovim
    nvim test.py

    # Should show LSP error (red squiggly)

**Test formatting**:

.. code-block:: vim

    <leader>f

Should format the file with darker.

Adding Custom Dependencies
===========================

If you need additional Python packages for your setup:

**Edit pyproject.toml**:

.. code-block:: toml

    [project]
    dependencies = [
        "pynvim>=0.4.3",
        "zuban>=0.2.0",
        "ruff>=0.1.0",
        "darker[isort]>=1.7.0",
        "my_custom_package>=1.0.0",  # Add here
    ]

**Install**:

.. code-block:: bash

    ~/.virtualenvs/nvim/bin/pip install my_custom_package

**Use in configuration**:

.. code-block:: lua

    -- In lua/utils/my_utils.lua
    local function use_custom_package()
        -- Python code via pynvim
    end

Troubleshooting Dependencies
============================

**Error: ModuleNotFoundError: No module named 'zuban'**

Solution: Install it:

.. code-block:: bash

    ~/.virtualenvs/nvim/bin/pip install zuban

**Error: Wrong Python being used**

Verify which Python Neovim is using:

.. code-block:: vim

    :checkhealth python

Should point to ``~/.virtualenvs/nvim/bin/python``.

If not, edit ``lua/lsp/lsp.lua``:

.. code-block:: lua

    settings = {
        python = {
            pythonPath = os.getenv('HOME') .. '/.virtualenvs/nvim/bin/python',
        }
    }

**Error: Version conflict**

Some packages may require specific versions:

.. code-block:: bash

    ~/.virtualenvs/nvim/bin/pip install --upgrade zuban pynvim

**Virtual environment not found**

Create it:

.. code-block:: bash

    python3 -m venv ~/.virtualenvs/nvim
    ~/.virtualenvs/nvim/bin/pip install pynvim zuban ruff "darker[isort]"

Performance Tips
================

**Installation is slow**:

Use ``uv`` for faster installation:

.. code-block:: bash

    pip install uv
    uv pip install pynvim zuban ruff "darker[isort]"

Much faster than standard pip.

**Large virtual environment**:

You can delete and recreate if needed:

.. code-block:: bash

    rm -rf ~/.virtualenvs/nvim
    python3 -m venv ~/.virtualenvs/nvim
    ~/.virtualenvs/nvim/bin/pip install pynvim zuban ruff "darker[isort]"

**Alternative: Use system Python**:

If you don't want to use a virtual environment:

Edit ``lua/lsp/lsp.lua``:

.. code-block:: lua

    settings = {
        python = {
            pythonPath = "/usr/bin/python3",  # System Python
        }
    }

**Not recommended** - virtual environment is better for isolation.

Security Considerations
=======================

**Virtual environment isolation**:

Packages installed in ``~/.virtualenvs/nvim/`` don't affect system Python:

- Safer
- No conflicts
- Can be deleted and recreated
- Reproducible

**Keeping packages updated**:

Regularly check for security updates:

.. code-block:: bash

    ~/.virtualenvs/nvim/bin/pip install --upgrade pip
    ~/.virtualenvs/nvim/bin/pip install --upgrade pynvim zuban ruff darker

**Pinning versions**:

For reproducibility, specify exact versions:

.. code-block:: bash

    ~/.virtualenvs/nvim/bin/pip install pynvim==0.4.3 zuban==0.2.0

See the ``pyproject.toml`` for current versions.

Alternative Setups
==================

**Use Poetry**:

If your project uses Poetry:

.. code-block:: bash

    poetry add pynvim zuban ruff darker
    poetry run nvim

**Use uv**:

.. code-block:: bash

    uv venv ~/.virtualenvs/nvim
    uv pip install pynvim zuban ruff "darker[isort]"

**Use conda**:

.. code-block:: bash

    conda create -n nvim-env python=3.11
    conda activate nvim-env
    pip install pynvim zuban ruff "darker[isort]"

Dependencies Summary
====================

- **pynvim** - Neovim Python API
- **zuban** - Python LSP (code intelligence)
- **ruff** - Linter (code quality)
- **darker** - Formatter (code style)

All installed in a dedicated virtual environment at ``~/.virtualenvs/nvim``.

For more information on each tool, see their documentation:

- pynvim: https://github.com/neovim/pynvim
- zuban: https://github.com/zubanls/zuban
- ruff: https://github.com/astral-sh/ruff
- darker: https://github.com/akaihola/darker

For configuration details, see :doc:`lsp_configuration` and :doc:`customization`.
