==============
Install Script
==============

Reference documentation for the ``install.py`` installation script.

Overview
========

The ``install.py`` script automates the complete setup process for the Neovim configuration on macOS and Linux.

Running the Script
==================

**Basic usage**:

.. code-block:: bash

    python3 install.py

The script is interactive - you'll be prompted for each step:

.. code-block:: text

    Neovim v0.11.4 Setup
    ==================================================

    Create necessary directories? (y/n): y
    ✓ Created /Users/username/.config/nvim
    ...

    Continue with next step? (y/n): y
    ...

**What it installs**:

1. Neovim v0.11.4
2. Python virtual environment with required packages
3. Configuration symlinks
4. Treesitter language parsers
5. Optional: Rust tools (Linux only)

Installation Steps
==================

**Step 1: Create Directories**

Creates necessary directories:

- ``~/.config/nvim`` - Neovim configuration
- ``~/.virtualenvs`` - Python virtual environments
- ``~/.dotfiles/nvim`` - Configuration location (if needed)
- ``~/.local/bin`` - User binaries

**Step 2: Install Neovim**

**macOS**:

1. Checks for Homebrew
2. If installed: Uses ``brew install neovim``
3. If not installed: Downloads binary from GitHub
4. Extracts and sets up binary

**Linux**:

1. Downloads AppImage
2. Makes executable
3. Sets up in ``~/.apps/neovim/``

**Step 3: Setup Python Virtual Environment**

Creates isolated Python environment:

1. Creates ``~/.virtualenvs/nvim/``
2. Installs ``uv`` (fast Python package manager)
3. Creates virtual environment
4. Verifies creation

**Step 4: Clone Configuration**

Clones the Neovim configuration:

.. code-block:: bash

    git clone https://github.com/clintonsteiner/nvim.git ~/dotfiles/nvim

If directory exists, asks whether to use existing or replace.

**Step 5: Install Python Packages**

Installs into the virtual environment:

- pynvim
- zuban
- ruff
- darker

Uses ``uv pip install`` for speed.

**Step 6: Create Symlinks**

Links configuration to Neovim config directory:

.. code-block:: bash

    ln -s ~/dotfiles/nvim/init.lua ~/.config/nvim/init.lua
    ln -s ~/dotfiles/nvim/lua ~/.config/nvim/lua

**Step 7: Create Launch Script**

Creates ``~/.local/bin/nvim`` for easy launching.

**Step 8: Install Treesitter**

Installs syntax highlighting parsers:

- python
- lua
- comment
- vim
- vimdoc
- c
- sql
- query

**Step 9: Install Rust Tools** (Linux only)

Optionally installs:

- eza (modern ls replacement)
- fd (fast find)
- ctags (code navigation)

Customizing the Script
======================

**Edit the script**:

.. code-block:: bash

    vim install.py

**Common modifications**:

**Change Neovim version**:

.. code-block:: python

    self.neovim_version = "0.12.0"  # Change from 0.11.4

**Change installation paths**:

.. code-block:: python

    self.neovim_dir = self.home / "my_apps" / "neovim"

**Skip certain steps**:

Comment out in the ``run()`` method:

.. code-block:: python

    steps = [
        ("Creating directories", self.create_directories),
        # ("Downloading Neovim", self.download_neovim),  # Skip this
        # ...
    ]

**Change Python packages**:

Edit ``pyproject.toml``:

.. code-block:: toml

    [project]
    dependencies = [
        "pynvim>=0.4.3",
        "my-package>=1.0.0",  # Add custom package
    ]

Script Structure
================

**Class: NvimSetup**

Main class handling all setup operations.

**Key methods**:

- ``__init__`` - Initialize paths and load dependencies
- ``run`` - Main entry point
- ``create_directories`` - Create needed folders
- ``download_neovim`` - Install Neovim
- ``setup_venv`` - Create Python environment
- ``clone_config`` - Clone this configuration
- ``install_python_packages`` - Install dependencies
- ``create_symlinks`` - Link config files
- ``create_launch_script`` - Create launcher
- ``install_treesitter`` - Install language parsers
- ``install_cargo_tools`` - Install Rust tools

**Helper methods**:

- ``run_command`` - Execute shell commands safely
- ``confirm`` - Ask user for confirmation
- ``_load_dependencies`` - Read pyproject.toml

Error Handling
==============

The script handles errors gracefully:

.. code-block:: python

    try:
        subprocess.run(cmd, check=True, capture_output=False)
        return True
    except subprocess.CalledProcessError as e:
        print(f"✗ Failed to {description}: {e}")
        return False

**Common error messages**:

.. code-block:: text

    ✗ Failed to install Neovim: [error details]
    ✗ Command not found: brew
    ✗ Permission denied: /path/to/directory
```

If a step fails:

1. The script continues (doesn't abort)
2. Failed steps are tracked
3. Summary shows which steps failed
4. You can fix issues and run again

Automation
==========

**Run without prompts**:

The script requires user confirmation for each step. To automate (use with caution):

Create a wrapper script:

.. code-block:: bash

    #!/bin/bash
    (
        echo y
        echo y
        echo y
        # ... more y's for each prompt
    ) | python3 install.py

**Or modify install.py**:

.. code-block:: python

    # In install.py, replace:
    if not self.confirm("Create necessary directories?"):
        return False

    # With:
    # Automatically proceed
```

Running on CI/CD
================

The script can run in CI environments:

.. code-block:: yaml

    # GitHub Actions example
    - name: Setup Neovim
      run: |
        python3 install.py << EOF
        y
        y
        y
        y
        y
        y
        y
        y
        n
        EOF

Check Exit Code
===============

The script returns exit codes:

.. code-block:: bash

    python3 install.py
    echo $?  # 0 = success, 1 = failure

Use in scripts:

.. code-block:: bash

    python3 install.py
    if [ $? -ne 0 ]; then
        echo "Installation failed"
        exit 1
    fi

Dependencies
============

**Required**:

- Python 3.8+
- Git
- curl
- tar (for extraction)

**Optional**:

- Homebrew (macOS, for easy Neovim installation)
- cargo (for Rust tools on Linux)

**The script checks for these** and provides helpful error messages if missing.

Troubleshooting the Installer
=============================

**Error: File not found**

.. code-block:: text

    FileNotFoundError: [Errno 2] No such file or directory: 'python3 install.py'

**Solution**: Run from the correct directory:

.. code-block:: bash

    cd ~/dotfiles/nvim
    python3 install.py

**Error: Permission denied**

.. code-block:: text

    PermissionError: [Errno 13] Permission denied: '/Users/username/.config/nvim'

**Solution**: Fix permissions:

.. code-block:: bash

    chmod -R 755 ~/.config/nvim

**Error: Curl/Git not found**

**Solution**: Install missing tools:

.. code-block:: bash

    brew install git  # macOS
    sudo apt-get install git  # Linux

**Error: Virtual environment creation fails**

**Solution**: Ensure Python is working:

.. code-block:: bash

    python3 --version
    python3 -m venv ~/.virtualenvs/test-nvim

**Error: Treesitter installation hangs**

**Solution**: The installation takes time (minutes). Be patient.

If it truly hangs, cancel with Ctrl+C and check:

.. code-block:: bash

    nvim -c "TSInstall python lua comment vim vimdoc c sql query" -c "quit"

Manual Installation Alternative
=================================

If the script fails, you can install manually. See :doc:`installation` for step-by-step instructions.

Modifying the Script
====================

**Add new installation step**:

.. code-block:: python

    def install_custom_tool(self) -> bool:
        """Install a custom tool."""
        if not self.confirm("Install custom tool?"):
            return False

        if not self.run_command(
            ["curl", "-o", "/tmp/mytool", "https://example.com/mytool"],
            "download custom tool"
        ):
            return False

        print("✓ Installed custom tool")
        return True

Then add to ``steps`` in ``run()``:

.. code-block:: python

    steps = [
        # ... existing steps ...
        ("Installing custom tool", self.install_custom_tool),
    ]

**Change confirmation message**:

.. code-block:: python

    # Edit the confirm() call
    if not self.confirm("Install Neovim v{} (macOS only)?".format(self.neovim_version)):
        return False

Distributing Modified Versions
===============================

If you customize the script:

1. Keep it in your fork
2. Document changes in README
3. Share with others who want same setup

**Example**: Creating company-specific setup:

.. code-block:: bash

    # Fork the repo
    git clone https://github.com/yourcompany/nvim-config.git

    # Modify install.py for company standards
    vim install.py

    # Commit and push
    git add install.py
    git commit -m "Company-specific setup"
    git push

Developers can then run:

.. code-block:: bash

    git clone https://github.com/yourcompany/nvim-config.git
    cd nvim-config
    python3 install.py

Next Steps After Installation
==============================

After running the script:

1. **Verify installation**:

   .. code-block:: bash

       nvim
       :checkhealth

2. **Review configuration**:

   .. code-block:: bash

       cat ~/.config/nvim/init.lua

3. **Customize as needed**:

   See :doc:`customization` for how to modify.

4. **Add to PATH** (if needed):

   .. code-block:: bash

       export PATH=$HOME/.local/bin:$PATH

5. **Commit your customizations**:

   .. code-block:: bash

       cd ~/dotfiles/nvim
       git add .
       git commit -m "My customizations"

Getting Help
============

If the installer fails:

1. Note the error message
2. Check :doc:`troubleshooting`
3. Check ``:checkhealth`` in Neovim
4. Try manual installation (:doc:`installation`)
5. Report issue with error details

Source Code
===========

The complete script is in ``install.py`` - it's readable and well-commented.

You can:

- Read it to understand what it does
- Modify it for your needs
- Reference it in your own scripts
- Learn from it

The script is approximately 450 lines of well-structured Python.
