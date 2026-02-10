# Development Guide

This guide provides information for developers who want to understand, modify, or extend this Neovim configuration.

## Project Structure Overview

### Main Configuration Entry Point

**File:** `init.lua`

The main configuration file that loads the entire Neovim setup. It initializes:
- Plugin manager (Lazy.nvim via Neovim's built-in package management)
- Core settings and options
- Auto-commands and keybindings
- Plugin configurations

### Core Settings

**File:** `lua/autocmds.lua`

Defines auto-commands that trigger on events:
- File type specific settings
- Auto-formatting on save
- Terminal mode configurations
- Custom event handlers

### Status Line

**File:** `lua/statusline.lua`

A custom-built status line (winbar) implementation without plugins:
- Shows current mode with color coding
- Displays git status (via gitsigns)
- Shows active LSP clients
- Current file path and modification status
- Current class and function names

**Key Functions:**
- `get_mode_color()` - Returns color for current vim mode
- `status_line()` - Main status line renderer
- `win_bar()` - Window bar showing file path and context
- `get_lsp_names()` - Lists active language servers
- `_get_current_function_name()` - Gets current function context
- `_get_current_class_name()` - Gets current class context

### LSP Configuration

**File:** `lua/lsp/lsp.lua`

Configures the built-in Neovim LSP client:
- Zuban (Python Language Server) setup
- Ruff (Python linter) configuration
- Diagnostic settings
- On-attach handlers for LSP features

**Key Servers:**
- `python` - Zuban LSP for Python
- `ruff` - Fast Python linter

To add a new LSP server, create a new table with the server name as key and add it before the LSP enable calls.

### Plugin Configurations

**Directory:** `lua/plugin/`

Each plugin has its own configuration file:

#### fzf-lua.lua
Fuzzy finding and file search configuration using FZF-Lua.
- `:FzfLua files` - Find files
- `:FzfLua buffers` - Switch buffers
- `:FzfLua grep` - Search content
- `:FzfLua git_files` - Search git-tracked files

#### treesitter.lua
Tree-sitter parser configuration for syntax highlighting and code navigation.
Configures parsers for: python, lua, vim, javascript, json, yaml, markdown.

#### which-key.lua
Keybinding discovery and organization. Maps commands with organized groups.

### Utility Functions

**Directory:** `lua/utils/`

Helper functions organized by domain:

#### core.lua
General-purpose utilities:
- `save_session()` - Save Neovim session
- `toggle_text_wrap()` - Toggle text wrapping
- `toggle_diagnostics()` - Toggle diagnostic display

#### python.lua
Python-specific development utilities:
- `M.abbrev(text)` - Insert common abbreviations
- `M.get_pytest_cov_cmd()` - Generate pytest coverage command
- `M.get_pytest_single_test_arg()` - Get argument for single test
- `M.darker()` - Run darker code formatter

#### treesitter.lua
Tree-Sitter based utilities:
- `M.get_current_function_name()` - Get current function name
- `M.get_current_class_name()` - Get current class name

## Configuration Files

### pyproject.toml

Defines Python project metadata and dependencies:
- Project name, version, description
- Python version requirement (>=3.8)
- Runtime dependencies (pynvim, zuban, ruff, darker)
- Development dependencies (pytest, coverage, etc.) - Added during Phase 5

### install.py

Automated setup script that:
1. Creates necessary directories
2. Downloads and installs Neovim v0.11.4
3. Creates Python virtual environment using `uv`
4. Installs Python dependencies
5. Creates symlinks to configuration
6. Optionally installs Treesitter and Rust tools

**Key Classes:**
- `NvimSetup` - Main setup orchestrator

**Key Methods:**
- `run_command()` - Execute shell commands with error handling
- `confirm()` - Get user confirmation
- `download_neovim()` - Install Neovim
- `setup_venv()` - Create Python virtual environment
- `clone_config()` - Clone this repository
- `install_python_packages()` - Install Python dependencies
- `create_symlinks()` - Link configuration to `~/.config/nvim`

## Development Setup

### Using the Configuration Locally

1. Clone the repository:
   ```bash
   git clone https://github.com/clintonsteiner/nvim_config.git ~/dotfiles/nvim
   ```

2. Create symlinks to your Neovim config:
   ```bash
   mkdir -p ~/.config/nvim
   ln -sf ~/dotfiles/nvim/init.lua ~/.config/nvim/init.lua
   ln -sf ~/dotfiles/nvim/lua ~/.config/nvim/lua
   ```

3. Install dependencies:
   ```bash
   source ~/.virtualenvs/nvim/bin/activate
   pip install -e ~/dotfiles/nvim
   deactivate
   ```

### Testing Configuration Changes

1. Edit Lua files in `lua/`
2. Reload configuration in Neovim: `:source %` or `:luafile %`
3. Or restart Neovim: `:quit` and reopen

### Python Package Development

If modifying `install.py` or adding Python utilities:

1. Install development dependencies:
   ```bash
   pip install -e ".[dev]"
   ```

2. Run tests:
   ```bash
   pytest tests/ -v
   ```

3. Check code formatting:
   ```bash
   ruff check .
   darker --check .
   ```

## Common Customization Tasks

### Adding a New Keybinding

1. Edit `lua/plugin/which-key.lua`
2. Find the relevant section or create a new group
3. Add your mapping following the existing pattern:

```lua
{
  "<leader>x",
  ":YourCommand<CR>",
  desc = "Description of what this does"
}
```

4. Reload with `:source ~/.config/nvim/init.lua`

### Adding a New LSP Server

1. Edit `lua/lsp/lsp.lua`
2. Add configuration table before `vim.lsp.enable()` calls:

```lua
local servers = {
  -- ... existing servers
  javascript = {
    cmd = { "node", "/path/to/server" },
    -- ... other config
  },
}
```

3. Add enable call:

```lua
vim.lsp.enable("javascript")
```

### Creating a Python Utility Function

1. Edit `lua/utils/python.lua` (or create new file in `lua/utils/`)
2. Add function to module `M`:

```lua
function M.my_function()
  -- Your code here
  return result
end
```

3. Use in other files:

```lua
local utils = require('utils.python')
utils.my_function()
```

### Modifying Status Line

Edit `lua/statusline.lua`:

1. Find the relevant function (e.g., `status_line()`)
2. Modify the string concatenation to change appearance
3. Use vim highlighting groups (e.g., `%#InsertMode#`) for colors
4. Test with `:set statusline=%!luaeval(\"status_line()\")`

## Coding Standards

### Lua

1. **Module Pattern**: Use `local M = {}` and `return M` for modules
2. **Functions**: Use `function M.name()` for exported functions
3. **Naming**: Use `snake_case` for functions and variables
4. **Comments**: Use `--` for single-line comments
5. **Luacheck**: Run `luacheck lua/` to check code quality

### Python

1. **Type Hints**: Add type annotations to function signatures
2. **Docstrings**: Use Google-style docstrings for classes and functions
3. **Naming**: Follow PEP 8 conventions
4. **Formatting**: Use darker for in-place formatting
5. **Linting**: Use ruff for linting

Example Python function:

```python
def install_neovim(self) -> bool:
    """Install Neovim on the current system.

    Args:
        None

    Returns:
        True if installation succeeded, False otherwise
    """
    # Implementation
    return True
```

## Git Workflow

### Commit Messages

Follow conventional commits format:

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation updates
- `refactor:` - Code refactoring
- `test:` - Test additions or changes
- `chore:` - Build process, dependencies, tooling
- `ci:` - CI/CD configuration changes

Example:
```
feat: add Python debugging support

- Configure debugpy integration
- Add keybindings for debugging
- Update documentation

Co-Authored-By: Your Name <email@example.com>
```

### Branch Naming

Use descriptive branch names:
- `feature/add-debugger`
- `fix/lsp-not-starting`
- `docs/update-readme`

## Testing

### Unit Tests

Tests are located in `tests/` directory:

```bash
# Run all tests
pytest tests/ -v

# Run specific test file
pytest tests/test_install.py -v

# Run with coverage
pytest tests/ --cov=. --cov-report=html
```

### Test Structure

```
tests/
├── conftest.py              # Shared fixtures
├── test_install.py          # Tests for install.py
└── python/
    └── test_python_utils.py # Tests for Python utilities
```

## Debugging

### Lua Debugging

1. Check for errors: `:messages`
2. Debug print statements:
   ```lua
   print(vim.inspect(variable))
   ```
3. Check syntax: `:luafile lua/file.lua`
4. Reload config: `:source ~/.config/nvim/init.lua`

### Python Debugging

1. Add breakpoint:
   ```python
   breakpoint()  # Requires Python 3.7+
   ```

2. Print debugging:
   ```python
   print(f"Debug: {variable}")
   ```

3. Check imports:
   ```bash
   python -c "import module; print(module.__file__)"
   ```

## Performance Optimization

### Profiling Startup Time

```vim
:profile start /tmp/nvim.log
:profile func *
:profile file *
" ... do something ...
:profile stop
" View results
:e /tmp/nvim.log
```

### Common Slowdowns

1. **Too many plugins** - Remove unused plugins from init.lua
2. **Slow LSP** - Check Zuban is installed correctly
3. **Large files** - Consider disabling some features for large files
4. **Terminal rendering** - Check terminal application performance

## References

- [Neovim LSP Documentation](https://neovim.io/doc/user/lsp.html)
- [Lua Language](https://www.lua.org/manual/5.1/)
- [Tree-sitter](https://tree-sitter.github.io/)
- [FZF](https://github.com/junegunn/fzf)
- [Zuban LSP](https://github.com/zubanls/zuban)
- [Darker](https://github.com/akaihola/darker)
- [Ruff](https://github.com/astral-sh/ruff)

## Troubleshooting Development

### "Module not found" errors

Ensure the module path is correct:
```lua
-- Correct: from lua/ directory
local utils = require('utils.python')

-- Incorrect: don't include lua/ in path
local utils = require('lua.utils.python')  -- WRONG
```

### Changes not taking effect

1. Reload configuration: `:source ~/.config/nvim/init.lua`
2. Restart Neovim
3. Clear cache: `rm -rf ~/.cache/nvim`

### LSP not recognizing changes

1. Restart LSP: `:LspRestart`
2. Verify LSP is running: `:LspInfo`
3. Check Python path: `python -c "import sys; print(sys.executable)"`
