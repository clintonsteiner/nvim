# Neovim Configuration for Polyglot Development

A minimal, pragmatic Neovim (v0.11.4+) configuration optimized for Python-first workflows with strong multi-language support (Go, Groovy, C/C++, SQL, TypeScript/JavaScript, Rust, Java), featuring FZF integration, custom status line, lazy loading, built-in LSP, and Mason auto-install.

## Features

- **Minimal plugin setup** - Only essential plugins with careful curation
- **FZF-powered fuzzy finding** - File search, buffer switching, git operations
- **Python-first design** - Optimized for Python development workflows
- **Go support** - Uses gopls for Go language intelligence
- **Polyglot LSP support** - Zuban/Ruff (Python), gopls (Go), groovyls, clangd, sqls, ts_ls, rust_analyzer, jdtls, and jsonls
- **Auto-install servers** - Mason installs missing non-Python LSP servers
- **Code formatting** - Darker with isort for in-place Python code formatting
- **Treesitter integration** - Enhanced syntax highlighting and code navigation
- **Custom status line** - Lightweight, custom-built status bar with LSP info
- **Smart keybindings** - Organized with which-key for discoverability

## Quick Start

### Automated Installation

The easiest way to set up this configuration:

```bash
git clone https://github.com/clintonsteiner/nvim.git ~/dotfiles/nvim
cd ~/dotfiles/nvim
python3 install.py
```

The `install.py` script will guide you through:
1. Creating necessary directories
2. Installing Neovim v0.11.4
3. Setting up a Python virtual environment
4. Cloning this configuration
5. Installing Python dependencies
6. Creating symlinks to the configuration
7. Installing Treesitter language support
8. Optionally installing Rust tools (eza, fd, ctags)

### Manual Installation

If you prefer manual setup, see [DEVELOPMENT.md](DEVELOPMENT.md) for step-by-step instructions.

After first launch:

```vim
:Lazy sync
:CheckDevEnv
```

If a filetype has no server installed yet:

```vim
:LspInstallMissing
```

## Configuration Structure

```
nvim/
├── init.lua                    # Main entry point
├── lua/
│   ├── autocmds.lua           # Autocommands and event handlers
│   ├── statusline.lua         # Custom status line implementation
│   ├── lsp/
│   │   └── lsp.lua            # LSP configuration
│   ├── plugin/
│   │   ├── fzf-lua.lua        # FZF fuzzy finder setup
│   │   ├── treesitter.lua     # Treesitter parser configuration
│   │   └── which-key.lua      # Which-key keybinding helper
│   └── utils/
│       ├── core.lua           # Core utility functions
│       ├── python.lua         # Python-specific utilities
│       └── treesitter.lua     # Treesitter helper functions
├── install.py                 # Automated setup script
├── pyproject.toml             # Python dependencies
└── lazy-lock.json             # Plugin lockfile
```

## Python Development Workflow

### Running Tests

Execute the current test file with pytest:
```
<leader>py
```

Run a specific test function:
```
<leader>pz
```

Generate coverage report for current module:
```
<leader>pc
```

### Code Formatting

Format Python file with darker (manual only; no format-on-save):
```
<leader>lf
```

Darker preserves line length (140 chars) and uses isort for import sorting.

### LSP Features

Code navigation and completion are provided by Zuban (Python LSP):
- Go to definition: `gd`
- Find references: `gr`
- Rename symbol: `<leader>rn`
- Code completion: `<C-x><C-o>` or configured with nvim-cmp

## Python Dependencies

The configuration requires these Python packages in the Neovim virtual environment:

- **pynvim** (>=0.4.3) - Python bindings for Neovim
- **zuban** (>=0.2.0) - Python Language Server (Rust-based)
- **ruff** (>=0.1.0) - Fast Python linter
- **darker** (>=1.7.0) - In-place code formatter with isort integration

These are installed automatically by `install.py` or can be installed manually:

```bash
source ~/.virtualenvs/nvim/bin/activate
pip install pynvim zuban ruff "darker[isort]"
deactivate
```

## Key Bindings

All keybindings are organized with which-key for easy discovery. Press `<leader>` and wait to see available commands.

### Core Navigation

| Key | Action |
|-----|--------|
| `<C-f>` | Find files |
| `<C-b>` | Switch buffers |
| `<C-g>` | Search git files |
| `<leader>r` | Search in current directory |
| `<leader>s` | Search in selection |
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Show documentation |

### Python Development

| Key | Action |
|-----|--------|
| `<leader>py` | Run pytest on current file |
| `<leader>pz` | Run specific test under cursor |
| `<leader>pc` | Generate coverage report |
| `<leader>lf` | Format file with darker |

### Text Manipulation

| Key | Action |
|-----|--------|
| `<leader>tw` | Toggle text wrap |
| `<leader>td` | Toggle diagnostics |
| `<leader>th` | Toggle inlay hints |
| `<leader>s` | Save session |

## Requirements

- **Neovim** >= 0.11.4
- **Python** >= 3.8 (for LSP and formatting tools)
- **Git** (for cloning repositories)
- **FZF** (for fuzzy finding)
- **Ripgrep** (for file searching)
- **A Nerd Font** (for proper icon display)

### Optional but Recommended

- **Homebrew** (macOS) - For easy Neovim installation
- **Cargo** (Rust package manager) - For building tools like `fd` and `eza`
- **Language servers** - `gopls`, `groovy-language-server`, `clangd`, `sqls`, `typescript-language-server`, `rust-analyzer`, `jdtls`, `vscode-json-language-server`

## Troubleshooting

### Issue: LSP not activating

1. Verify Python virtual environment is set up:
   ```bash
   ls -la ~/.virtualenvs/nvim
   ```

2. Check that Zuban is installed:
   ```bash
   ~/.virtualenvs/nvim/bin/python -m pip list | grep zuban
   ```

3. Run `:LspInfo` and `:CheckDevEnv` in Neovim to see LSP status

### Issue: FZF not working

1. Install FZF:
   ```bash
   git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
   ~/.fzf/install
   ```

2. Install ripgrep (used by fzf for file searching):
   ```bash
   brew install ripgrep  # macOS
   sudo apt-get install ripgrep  # Linux
   ```

### Issue: Treesitter parser missing

Run this in Neovim:
```vim
:TSInstall python go gomod gowork gosum groovy c cpp sql javascript typescript rust java json lua comment vim vimdoc query
```

Or use the setup script option when running `install.py`.

### Issue: Icons not displaying correctly

Install a Nerd Font (e.g., IntelOneMono Nerd Font):
- Download from: https://github.com/ryanoasis/nerd-fonts
- Set it as your terminal font in your terminal application settings

## Customization

### Adding New Keybindings

Edit `lua/plugin/which-key.lua` to add new keybindings. The which-key integration makes it easy to discover your shortcuts.

### Adding LSP Servers

Edit `lua/lsp/lsp.lua` to add additional language servers. The configuration uses the built-in Neovim LSP client.

### Installing Missing LSP Servers

Use:
```vim
:LspInstallMissing
```

This installs Mason-managed LSP packages for the current buffer filetype.

### Configuring Plugins

Each plugin has its own configuration file in `lua/plugin/`. Modify these files to customize plugin behavior.

See [DEVELOPMENT.md](DEVELOPMENT.md) for detailed customization examples.

## Development

For information on modifying this configuration, extending it, or contributing, see [DEVELOPMENT.md](DEVELOPMENT.md).

## Project Philosophy

This configuration follows these principles:

1. **Use as few plugins as possible** - Every plugin must earn its place
2. **Leverage FZF heavily** - For powerful, fast fuzzy finding
3. **Build custom solutions** - When appropriate (e.g., status line, utilities)
4. **Focus on Python development** - But maintain flexibility for other languages
5. **Keep it fast** - Startup time and responsiveness matter

## License

This is a personal configuration made public for sharing. Feel free to adapt it to your needs.

## References

- [Neovim Documentation](https://neovim.io/doc/)
- [Zuban Language Server](https://github.com/zubanls/zuban)
- [FZF](https://github.com/junegunn/fzf)
- [Treesitter](https://tree-sitter.github.io/)
- [Ruff](https://github.com/astral-sh/ruff)
- [Darker](https://github.com/akaihola/darker)
