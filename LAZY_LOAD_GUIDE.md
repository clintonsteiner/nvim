# Lazy Load Python LSP and Utils - Installation Guide

## Overview
This guide explains the lazy loading implementation that defers Python LSP and Python-specific utilities until they're actually needed. This improves startup time for non-Python editing.

## What Changed

### File Structure
```
lua/
├── utils/
│   ├── core.lua          (NEW - immediate load)
│   ├── python.lua        (NEW - lazy load on ft=python)
│   └── treesitter.lua    (NEW - immediate load)
└── (deleted: utils.lua)  (REMOVED - replaced by above)

(deleted: constants.lua)  (REMOVED - inlined into lsp.lua)
```

### Module Organization

#### `lua/utils/core.lua` - Loaded immediately
- `save_session()` - keybind: `<leader>s`
- `toggle_text_wrap()` - keybind: `<leader>tw`
- `toggle_diagnostics()` - keybind: `<leader>td`

#### `lua/utils/python.lua` - Lazy loaded on `ft=python`
- `abbrev()` - Python break statements, pdb
- `get_pytest_cov_cmd()` - pytest coverage commands
- `get_pytest_single_test_arg()` - test under cursor
- `get_last_test_name()` - last run test (NEW)
- `darker()` - Python formatter

#### `lua/utils/treesitter.lua` - Loaded immediately
- `M.get_current_class_name()` - get class from treesitter
- `M.get_current_function_name()` - get function from treesitter

### Configuration Changes

#### `init.lua`
- **Line 18-24**: nvim-lspconfig now lazy loads with `ft = "python"`
- **Line 96-97**: Changed from `require "utils"` to:
  - `require "utils.core"` (core utilities)
  - `require "utils.treesitter"` (treesitter helpers)
- **Removed line 86**: `require "lsp"` (now loaded via lazy.nvim)

#### `lua/autocmds.lua`
- **Lines 11-17**: New FileType autocommand loads `utils.python` when opening Python files

#### `lua/lsp/lsp.lua`
- **Lines 1-28**: Inlined `kind_icons` from `constants.lua` (removed dependency)

#### `lua/plugin/which-key.lua`
- **Lines 45-48**: Python `abbrev()` calls updated to `require('utils.python').abbrev()`
- **Line 53**: `darker()` updated to `require('utils.python').darker()`
- **Lines 67-68**: `get_pytest_cov_cmd()` calls via module
- **Line 70**: `get_last_test_name()` calls via module
- **Line 74**: `get_pytest_single_test_arg()` calls via module

#### `lua/statusline.lua`
- **Lines 57-58**: Updated to `require('utils.treesitter').get_current_class_name()`
- **Lines 70-71**: Updated to `require('utils.treesitter').get_current_function_name()`

#### `lua/plugin/treesitter.lua`
- **Removed lines 4-38**: Moved `get_current_class_name()` and `get_current_function_name()` to `utils/treesitter.lua`

### Code Quality

#### `.luacheckrc` (NEW)
Configures luacheck to:
- Recognize `vim` as a global (Neovim API)
- Allow defining globals in config files
- Ignore expected warnings for this configuration style

#### `.git/hooks/pre-commit` (NEW)
Git pre-commit hook that:
- Runs luacheck on all staged `.lua` files
- Prevents commits with luacheck warnings/errors
- Ensures code quality on every commit

## Installation Instructions

### Step 1: Review Changes
Check the modifications to ensure they align with your setup:
```bash
git status
```

### Step 2: Verify Lua Syntax
```bash
luacheck lua/utils/ lua/lsp/lsp.lua lua/autocmds.lua \
  lua/statusline.lua lua/plugin/treesitter.lua \
  lua/plugin/which-key.lua init.lua
```

Expected output: 5 warnings (all are expected/ignored)

### Step 3: Test Non-Python Startup
Open a non-Python file and verify LSP doesn't load:
```bash
nvim init.lua
:LspInfo  # Should show no LSP clients
```

### Step 4: Test Python File Loading
Open a Python file and verify LSP loads:
```bash
nvim test.py
:LspInfo  # Should show zuban and ruff LSP clients
```

### Step 5: Test Core Utils Work Immediately
```bash
nvim init.lua
<leader>s   # Should prompt for session name
<leader>td  # Should toggle diagnostics
<leader>tw  # Should toggle text wrap
```

### Step 6: Test Python Utils Load on Demand
```bash
nvim test.py
<leader>ib  # Should insert breakpoint line
<leader>lf  # Should run darker formatter
<leader>pz  # Should run test under cursor
```

### Step 7: Commit Changes
Once verified, commit:
```bash
git add .
git commit -m "Lazy load Python LSP and utils..."
```

## Verification Checklist

### Startup Performance
- [ ] Non-Python files open without LSP
- [ ] No performance degradation on startup
- [ ] Memory usage reasonable for non-Python editing

### Core Functionality
- [ ] `<leader>s` (save session) works
- [ ] `<leader>td` (toggle diagnostics) works
- [ ] `<leader>tw` (toggle text wrap) works

### Python Functionality
- [ ] Python files load zuban and ruff LSP
- [ ] `<leader>ib` (insert break) works on Python files
- [ ] `<leader>lf` (darker formatter) works on Python files
- [ ] `<leader>pz` (test under cursor) works on Python files
- [ ] Winbar shows class/function name in Python files
- [ ] Winbar doesn't show on non-Python files

### Code Quality
- [ ] `luacheck` passes with expected warnings only
- [ ] Pre-commit hook runs on git commit
- [ ] No errors in hook output

## Troubleshooting

### "LSP loads on non-Python files"
Check that init.lua line 19-20 has `ft = "python"` in the nvim-lspconfig spec.

### "Python utils not available in Python files"
Verify autocmds.lua lines 11-17 exist and pattern is `"python"`.

### "luacheck hook fails on commit"
Run `luacheck lua/` locally to see errors, fix, then retry commit.

### "Class/function name not in winbar"
Verify statusline.lua requires `utils.treesitter` module (lines 57, 70).

## Performance Impact

### Expected Improvements
- **Startup time**: 50-100ms faster for non-Python files
- **Memory**: Reduced when editing non-Python code
- **LSP overhead**: Completely eliminated until Python file is opened

### No Impact
- Python file editing experience (all features still available)
- Core keybindings and utilities
- Existing statusline/winbar functionality

## Rollback

If issues occur, rollback with:
```bash
git revert HEAD
nvim
```

## Support

For issues:
1. Verify all changes were applied (`git diff`)
2. Check luacheck output for syntax errors
3. Test each verification step individually
4. Review the relevant Lua file if a specific feature fails
