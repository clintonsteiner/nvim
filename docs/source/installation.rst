============
Installation
============

This guide covers how to install and set up the Neovim configuration.

Automated Installation (Recommended)
====================================

The easiest way to set up this configuration is to use the automated installation script:

.. code-block:: bash

    git clone https://github.com/clintonsteiner/nvim.git ~/dotfiles/nvim
    cd ~/dotfiles/nvim
    python3 install.py

The ``install.py`` script will guide you through an interactive setup process and handle all the following steps:

1. **Creating necessary directories** - Creates `~/.config/nvim`, `~/.virtualenvs`, and other required paths
2. **Installing Neovim v0.11.4** - Uses Homebrew on macOS or downloads the binary directly
3. **Setting up a Python virtual environment** - Creates an isolated Python environment using ``uv``
4. **Installing Python dependencies** - Sets up all required Python packages (pynvim, zuban, ruff, darker)
5. **Creating symlinks** - Links the configuration to your Neovim config directory
6. **Installing Treesitter** - Downloads language parsers for syntax highlighting
7. **Optional: Installing Rust tools** - Installs eza, fd, and ctags (Linux only)

Manual Installation
===================

If you prefer more control or encounter issues with the automated script:

.. code-block:: bash

    # 1. Clone the configuration
    git clone https://github.com/clintonsteiner/nvim.git ~/dotfiles/nvim

    # 2. Create directories
    mkdir -p ~/.config/nvim
    mkdir -p ~/.virtualenvs
    mkdir -p ~/.local/bin

    # 3. Create Python virtual environment
    python3 -m venv ~/.virtualenvs/nvim
    source ~/.virtualenvs/nvim/bin/activate

    # 4. Install Python dependencies
    pip install pynvim zuban ruff "darker[isort]"
    deactivate

    # 5. Create symlinks
    ln -s ~/dotfiles/nvim/init.lua ~/.config/nvim/init.lua
    ln -s ~/dotfiles/nvim/lua ~/.config/nvim/lua

    # 6. Install Treesitter parsers
    nvim -c "TSInstall python lua comment vim vimdoc c sql query" -c "quit"

macOS-Specific Installation
=============================

**With Homebrew** (Recommended):

.. code-block:: bash

    brew install neovim python@3.11 fzf ripgrep

Then run the automated installation script.

**Without Homebrew**:

The script will download the Neovim binary directly. You'll still need to install:

.. code-block:: bash

    python3 -m pip install --user uv

Linux Installation
===================

Install dependencies first:

.. code-block:: bash

    # Debian/Ubuntu
    sudo apt-get update
    sudo apt-get install -y python3 python3-venv git fzf ripgrep cargo

    # Fedora
    sudo dnf install -y python3 python3-venv git fzf ripgrep cargo

Then run the automated installation script.

Verifying the Installation
===========================

After installation, verify everything is set up correctly:

.. code-block:: bash

    # Check Neovim version
    nvim --version

    # Check Python environment
    ~/.virtualenvs/nvim/bin/python -m pip list

    # Open Neovim and check health
    nvim +checkhealth

Look for any warnings in the health report, particularly for:

- Python provider (should use your virtual environment)
- LSP (should detect Zuban)
- Treesitter (should show installed parsers)

Troubleshooting Installation
=============================

**Virtual environment not found**:
Ensure the virtual environment exists at ``~/.virtualenvs/nvim``. If not, create it manually:

.. code-block:: bash

    python3 -m venv ~/.virtualenvs/nvim

**Neovim not found**:
Check that Neovim is installed and in your PATH:

.. code-block:: bash

    which nvim
    nvim --version

If using the binary installation, ensure ``~/.local/bin`` is in your ``$PATH``:

.. code-block:: bash

    export PATH=$HOME/.local/bin:$PATH

**LSP not activating**:
Check that Zuban is installed in the virtual environment:

.. code-block:: bash

    ~/.virtualenvs/nvim/bin/python -m pip list | grep zuban

If not installed, install it:

.. code-block:: bash

    ~/.virtualenvs/nvim/bin/pip install zuban

See the :doc:`troubleshooting` section for more detailed help.
