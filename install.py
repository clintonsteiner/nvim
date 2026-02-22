#!/usr/bin/env python3
"""
Automated Neovim setup script.
Sets up Neovim v0.11.4 from scratch with all dependencies.
"""

import os
import sys
import subprocess
import shutil
import tomllib
import platform
from pathlib import Path
from typing import Optional, List


class NvimSetup:
    """Handle Neovim setup process."""

    def __init__(self):
        self.neovim_version = "0.11.4"
        self.home = Path.home()
        self.neovim_dir = self.home / "apps" / "neovim"
        self.venv_dir = self.home / ".virtualenvs" / "nvim"
        self.dotfiles_dir = self.home / "dotfiles"
        self.nvim_config_dir = self.home / ".config" / "nvim"
        self.local_bin_dir = self.home / ".local" / "bin"
        self.script_dir = Path(__file__).parent
        self.pyproject_path = self.script_dir / "pyproject.toml"
        self.dependencies = self._load_dependencies()

    def _load_dependencies(self) -> List[str]:
        """Load dependencies from pyproject.toml."""
        if not self.pyproject_path.exists():
            print(f"⚠ {self.pyproject_path} not found, using defaults")
            return [
                "pynvim",
                "zuban",
                "ruff",
                "darker[isort]",
            ]

        try:
            with open(self.pyproject_path, "rb") as f:
                data = tomllib.load(f)
            dependencies = data.get("project", {}).get("dependencies", [])
            return dependencies if dependencies else []
        except Exception as e:
            print(f"⚠ Failed to read pyproject.toml: {e}, using defaults")
            return [
                "pynvim",
                "zuban",
                "ruff",
                "darker[isort]",
            ]

    def run_command(self, cmd: list, description: str, check: bool = True) -> bool:
        """Run a shell command with error handling."""
        try:
            subprocess.run(cmd, check=check, capture_output=False)
            return True
        except subprocess.CalledProcessError as e:
            print(f"✗ Failed to {description}: {e}")
            return False
        except FileNotFoundError:
            print(f"✗ Command not found: {cmd[0]}")
            return False

    def confirm(self, message: str) -> bool:
        """Ask user for confirmation."""
        while True:
            response = input(f"\n{message} (y/n): ").strip().lower()
            if response in ("y", "yes"):
                return True
            elif response in ("n", "no"):
                return False
            print("Please enter 'y' or 'n'")

    def create_directories(self) -> bool:
        """Create necessary directories."""
        if not self.confirm("Create necessary directories?"):
            return False

        dirs = [
            self.neovim_dir,
            self.venv_dir.parent,
            self.dotfiles_dir,
            self.nvim_config_dir,
            self.local_bin_dir,
        ]

        for directory in dirs:
            try:
                directory.mkdir(parents=True, exist_ok=True)
                print(f"✓ Created {directory}")
            except Exception as e:
                print(f"✗ Failed to create {directory}: {e}")
                return False

        return True

    def download_neovim(self) -> bool:
        """Download or install Neovim."""
        if not self.confirm(f"Install Neovim v{self.neovim_version}?"):
            return False

        system = platform.system()

        if system == "Darwin":  # macOS
            return self._install_neovim_macos()
        elif system == "Linux":
            return self._install_neovim_linux()
        else:
            print(f"✗ Unsupported system: {system}")
            return False

    def _install_neovim_macos(self) -> bool:
        """Install Neovim on macOS using Homebrew."""
        # Check if Homebrew is installed
        result = subprocess.run(["which", "brew"], capture_output=True)
        if result.returncode == 0:
            print("Using Homebrew to install Neovim...")
            return self.run_command(["brew", "install", "neovim"], "install Neovim with Homebrew")
        else:
            print("⚠ Homebrew not found. Installing Neovim binary instead...")
            return self._download_neovim_macos_binary()

    def _download_neovim_macos_binary(self) -> bool:
        """Download Neovim macOS binary."""
        self.neovim_dir.mkdir(parents=True, exist_ok=True)

        nvim_dir = self.neovim_dir / "nvim.app"
        if nvim_dir.exists():
            if not self.confirm("Neovim.app already exists. Overwrite?"):
                return True
            shutil.rmtree(nvim_dir)

        # Determine architecture
        arch = "arm64" if platform.machine() == "arm64" else "x86_64"
        url = f"https://github.com/neovim/neovim/releases/download/v{self.neovim_version}/nvim-macos-{arch}.tar.gz"

        tar_path = self.neovim_dir / "nvim.tar.gz"
        cmd = ["curl", "-L", "-o", str(tar_path), url]

        if not self.run_command(cmd, "download Neovim macOS binary"):
            return False

        # Extract
        cmd = ["tar", "-xzf", str(tar_path), "-C", str(self.neovim_dir)]
        if not self.run_command(cmd, "extract Neovim"):
            return False

        tar_path.unlink()
        print(f"✓ Downloaded and extracted Neovim")
        return True

    def _install_neovim_linux(self) -> bool:
        """Download Neovim AppImage for Linux."""
        nvim_path = self.neovim_dir / "nvim.appimage"

        if nvim_path.exists():
            if not self.confirm("Neovim appimage already exists. Overwrite?"):
                return True
            nvim_path.unlink()

        url = f"https://github.com/neovim/neovim/releases/download/v{self.neovim_version}/nvim-linux-x86_64.appimage"
        cmd = ["curl", "-L", "-o", str(nvim_path), url]

        if not self.run_command(cmd, "download Neovim"):
            return False

        try:
            nvim_path.chmod(0o755)
            print(f"✓ Downloaded and made executable: {nvim_path}")
            return True
        except Exception as e:
            print(f"✗ Failed to make executable: {e}")
            return False

    def setup_venv(self) -> bool:
        """Create and setup Python virtual environment with uv."""
        if not self.confirm("Create Python virtual environment?"):
            return False

        # Check if uv is installed
        result = subprocess.run(["which", "uv"], capture_output=True)
        if result.returncode != 0:
            print("✗ uv not found. Installing uv...")
            if not self.run_command(["pip", "install", "uv"], "install uv"):
                return False

        if self.venv_dir.exists():
            if self.confirm("Virtual environment already exists. Delete and recreate?"):
                shutil.rmtree(self.venv_dir)
            else:
                return True

        if not self.run_command(["uv", "venv", str(self.venv_dir)],
                               "create virtual environment with uv"):
            return False

        print(f"✓ Created virtual environment at {self.venv_dir}")
        return True

    def clone_config(self) -> bool:
        """Clone Neovim config repository."""
        if not self.confirm("Clone Neovim configuration?"):
            return False

        nvim_config_path = self.dotfiles_dir / "nvim"

        if nvim_config_path.exists():
            if not self.confirm("Configuration already exists. Use existing?"):
                shutil.rmtree(nvim_config_path)
            else:
                return True

        cmd = [
            "git", "clone",
            "https://github.com/clintonsteiner/nvim.git",
            str(nvim_config_path)
        ]

        if not self.run_command(cmd, "clone configuration"):
            return False

        print(f"✓ Cloned configuration to {nvim_config_path}")
        return True

    def install_python_packages(self) -> bool:
        """Install Python packages from pyproject.toml using uv."""
        if not self.dependencies:
            print("✗ No dependencies found in pyproject.toml")
            return False

        package_names = ", ".join([dep.split("[")[0].split(">")[0].split("<")[0].split("=")[0] for dep in self.dependencies])
        if not self.confirm(f"Install Python packages ({package_names})?"):
            return False

        if not self.venv_dir.exists():
            print("✗ Virtual environment not found. Run setup_venv first.")
            return False

        # Use uv pip install with --python to target the venv
        python_exe = self.venv_dir / "bin" / "python"
        cmd = ["uv", "pip", "install", "--python", str(python_exe)] + self.dependencies
        if not self.run_command(cmd, "install packages with uv"):
            return False

        print(f"✓ Installed all packages")
        return True

    def create_symlinks(self) -> bool:
        """Create symlinks to Neovim configuration."""
        if not self.confirm("Create symlinks to configuration?"):
            return False

        nvim_config_path = self.dotfiles_dir / "nvim"

        symlinks = [
            (nvim_config_path / "init.lua", self.nvim_config_dir / "init.lua"),
            (nvim_config_path / "lua", self.nvim_config_dir / "lua"),
        ]

        for source, target in symlinks:
            if not source.exists():
                print(f"✗ Source not found: {source}")
                return False

            if target.exists() or target.is_symlink():
                target.unlink()

            try:
                target.symlink_to(source)
                print(f"✓ Created symlink: {target} -> {source}")
            except Exception as e:
                print(f"✗ Failed to create symlink: {e}")
                return False

        return True

    def create_launch_script(self) -> bool:
        """Create the Neovim launch script (if needed)."""
        system = platform.system()

        # On macOS with Homebrew, no launch script needed
        if system == "Darwin":
            result = subprocess.run(["which", "nvim"], capture_output=True)
            if result.returncode == 0:
                print("✓ Neovim installed via Homebrew, no launch script needed")
                return True

        if not self.confirm("Create Neovim launch script?"):
            return False

        script_path = self.local_bin_dir / "nvim"

        if system == "Darwin":
            # macOS binary installation
            nvim_bin = self.neovim_dir / "nvim.app" / "bin" / "nvim"
            script_content = f"""#!/usr/bin/env bash
{nvim_bin} "$@"
"""
        else:
            # Linux AppImage
            script_content = f"""#!/usr/bin/env bash
{self.neovim_dir}/nvim.appimage "$@"
"""

        try:
            with open(script_path, "w") as f:
                f.write(script_content)
            script_path.chmod(0o755)
            print(f"✓ Created launch script: {script_path}")
            return True
        except Exception as e:
            print(f"✗ Failed to create launch script: {e}")
            return False

    def check_path_setup(self) -> None:
        """Check if ~/.local/bin is in PATH."""
        local_bin = str(self.local_bin_dir)
        if local_bin not in os.environ.get("PATH", ""):
            print(f"\n⚠ {local_bin} is not in your PATH")
            print(f"Add this line to your ~/.bashrc or ~/.zshrc:")
            print(f"  export PATH=$HOME/.local/bin:$PATH")

    def _get_nvim_executable(self) -> Optional[str]:
        """Get path to Neovim executable based on system and installation method."""
        system = platform.system()

        if system == "Darwin":
            # Try Homebrew first
            result = subprocess.run(["which", "nvim"], capture_output=True, text=True)
            if result.returncode == 0:
                return result.stdout.strip()

            # Try binary installation
            nvim_bin = self.neovim_dir / "nvim.app" / "bin" / "nvim"
            if nvim_bin.exists():
                return str(nvim_bin)
        elif system == "Linux":
            nvim_path = self.neovim_dir / "nvim.appimage"
            if nvim_path.exists():
                return str(nvim_path)

        return None

    def install_treesitter(self) -> bool:
        """Optionally install Treesitter support."""
        if not self.confirm("Install Treesitter language support?"):
            return False

        nvim_path = self._get_nvim_executable()

        if not nvim_path:
            print("✗ Neovim not found. Cannot install Treesitter.")
            return False

        languages = "python go gomod gowork gosum groovy c cpp sql javascript typescript rust java json lua comment vim vimdoc query"
        cmd = [str(nvim_path), "-c", f"TSInstall {languages}", "-c", "quit"]

        print(f"Installing Treesitter languages: {languages}")
        return self.run_command(cmd, "install Treesitter languages")

    def install_cargo_tools(self) -> bool:
        """Optionally install Rust tools via cargo."""
        if not self.confirm("Install Rust tools (eza, fd, ctags)?"):
            return False

        # Check if cargo is installed
        result = subprocess.run(["which", "cargo"], capture_output=True)
        if result.returncode != 0:
            if not self.confirm("Cargo not found. Install it first (sudo apt-get install cargo)?"):
                return False
            if not self.run_command(["sudo", "apt-get", "install", "-y", "cargo"],
                                   "install cargo"):
                return False

        tools = ["eza", "fd-find"]

        for tool in tools:
            if not self.run_command(["cargo", "install", tool], f"install {tool}"):
                print(f"⚠ Failed to install {tool}, continuing...")

        # Install ctags separately (not a cargo tool)
        if not self.run_command(["sudo", "apt-get", "install", "-y", "ctags"],
                               "install ctags"):
            print("⚠ Failed to install ctags, continuing...")

        print("✓ Installed Rust tools")
        return True

    def run(self) -> None:
        """Run the complete setup."""
        print(f"Neovim v{self.neovim_version} Setup")
        print("=" * 50)

        steps = [
            ("Creating directories", self.create_directories),
            ("Downloading Neovim", self.download_neovim),
            ("Setting up virtual environment", self.setup_venv),
            ("Cloning configuration", self.clone_config),
            ("Installing Python packages", self.install_python_packages),
            ("Creating symlinks", self.create_symlinks),
            ("Creating launch script", self.create_launch_script),
            ("Installing Treesitter", self.install_treesitter),
            ("Installing Rust tools", self.install_cargo_tools),
        ]

        failed_steps = []

        for step_name, step_func in steps:
            try:
                if not step_func():
                    failed_steps.append(step_name)
            except KeyboardInterrupt:
                print("\n\n✗ Setup cancelled by user")
                sys.exit(1)
            except Exception as e:
                print(f"✗ Unexpected error in {step_name}: {e}")
                failed_steps.append(step_name)

        print("\n" + "=" * 50)
        if failed_steps:
            print(f"✗ Setup incomplete. Failed steps: {', '.join(failed_steps)}")
        else:
            print("✓ Setup complete!")

        self.check_path_setup()

        if self.confirm("\nLaunch Neovim now to install plugins?"):
            nvim_path = self._get_nvim_executable()
            if nvim_path:
                # Run nvim with :PlugInstall
                cmd = [str(nvim_path), "-c", "PlugInstall", "-c", "quit"]
                self.run_command(cmd, "install plugins")
            else:
                print("⚠ Could not find Neovim executable")


if __name__ == "__main__":
    setup = NvimSetup()
    setup.run()
