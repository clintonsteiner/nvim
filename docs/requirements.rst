============
Requirements
============

System Requirements
====================

**Operating Systems**:

- **macOS** 10.15 or later
- **Linux** (Debian, Ubuntu, Fedora, etc.)
- **Windows** is not officially supported (use WSL2 instead)

**Core Software**:

- **Neovim** >= 0.11.4
- **Python** >= 3.8
- **Git** >= 2.0

**Recommended Tools**:

- **FZF** - For fuzzy finding (integrated deeply into the config)
- **Ripgrep** (rg) - For fast file searching
- **A Nerd Font** - For proper icon display (e.g., Fira Code Nerd Font, JetBrains Mono)

**Optional Tools**:

- **Homebrew** (macOS) - Makes installation easier
- **Cargo** (Rust package manager) - For installing tools like ``fd`` and ``eza``
- **Make** - If building Neovim from source

Python Environment
===================

This configuration requires a Python virtual environment. The automated installer handles this, but you can also set it up manually:

.. code-block:: bash

    python3 -m venv ~/.virtualenvs/nvim
    source ~/.virtualenvs/nvim/bin/activate
    pip install pynvim zuban ruff "darker[isort]"
    deactivate

The configuration automatically detects and uses this environment.

Python Packages
===============

The following Python packages are installed in the virtual environment:

- **pynvim** (>=0.4.3) - Python bindings for Neovim
- **zuban** (>=0.2.0) - Python Language Server (Rust-based)
- **ruff** (>=0.1.0) - Fast Python linter
- **darker** (>=1.7.0) - In-place code formatter with isort integration

See :doc:`python_dependencies` for more details.

Platform-Specific Requirements
==============================

macOS
-----

**Minimal Setup**:

.. code-block:: bash

    # Install Homebrew (if not already installed)
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Install required tools
    brew install neovim python@3.11 git fzf ripgrep

**Optional**:

.. code-block:: bash

    brew install cargo  # For Rust tools

Linux (Debian/Ubuntu)
---------------------

.. code-block:: bash

    sudo apt-get update
    sudo apt-get install -y \
        neovim \
        python3 \
        python3-venv \
        git \
        fzf \
        ripgrep \
        curl

**Optional**:

.. code-block:: bash

    sudo apt-get install -y cargo  # For Rust tools

Linux (Fedora)
--------------

.. code-block:: bash

    sudo dnf install -y \
        neovim \
        python3 \
        python3-venv \
        git \
        fzf \
        ripgrep \
        curl

**Optional**:

.. code-block:: bash

    sudo dnf install -y cargo  # For Rust tools

Font Setup
==========

For proper display of icons and symbols, install a Nerd Font:

1. Download from `Nerd Fonts <https://www.nerdfonts.com/>`_
2. Install on your system:

   - **macOS**: Double-click the `.otf` or `.ttf` file
   - **Linux**: Copy to ``~/.local/share/fonts/`` and run ``fc-cache -fv``

3. Set as your terminal's font in settings

Recommended Nerd Fonts:

- FiraCode Nerd Font
- JetBrains Mono Nerd Font
- Inconsolata Nerd Font
- IBM Plex Mono Nerd Font

Verifying Requirements
======================

Before installation, verify you have everything:

.. code-block:: bash

    # Check Neovim
    nvim --version

    # Check Python
    python3 --version

    # Check Git
    git --version

    # Check FZF (optional but recommended)
    fzf --version

    # Check Ripgrep (optional but recommended)
    rg --version

Minimum Disk Space
==================

- **Neovim**: ~200 MB
- **Python environment**: ~300 MB
- **Virtual environment**: ~100 MB
- **Configuration files**: ~5 MB

Total: Approximately 600 MB

Internet Connection
===================

Required for:

- Cloning the repository
- Installing Python packages
- Downloading Treesitter parsers
- Installing plugins (on first launch)
- LSP operations (connecting to language servers)

After initial setup, most features work offline.

Checking Your Setup
===================

After installation, verify everything is working:

.. code-block:: bash

    # In Neovim
    :checkhealth

Check for any warnings, especially for:

- Python provider
- Ruby/Node providers (can ignore if not used)
- LSP
- Treesitter

All critical checks should pass (show "ok").
