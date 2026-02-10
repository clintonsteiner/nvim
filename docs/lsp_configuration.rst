==================
LSP Configuration
==================

Detailed configuration options for the Language Server Protocol.

Basic LSP Setup
===============

LSP is configured in ``lua/lsp/lsp.lua``. The file sets up:

- Zuban (Python language server)
- Capabilities
- Diagnostics
- Keybindings

The configuration is initialized in ``lua/lsp/init.lua``.

Zuban Configuration
===================

Zuban settings in ``lua/lsp/lsp.lua``:

.. code-block:: lua

    lsp.pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            python = {
                analysis = {
                    -- Configuration here
                }
            }
        }
    })

Key Settings
============

**Python Path**:

Specify which Python interpreter to use:

.. code-block:: lua

    settings = {
        python = {
            pythonPath = os.getenv('HOME') .. '/.virtualenvs/nvim/bin/python',
        }
    }

By default, LSP auto-detects the virtual environment.

**Type Checking**:

Control how strict type checking is:

.. code-block:: lua

    analysis = {
        typeCheckingMode = "basic",  -- "off", "basic", "strict"
    }

**Diagnostics Settings**:

Global diagnostic configuration:

.. code-block:: lua

    vim.diagnostic.config({
        virtual_text = true,        -- Show errors inline
        signs = true,               -- Show signs in gutter
        underline = true,           -- Underline errors
        update_in_insert = false,   -- Don't update while typing
        severity_sort = true,       -- Sort by severity
    })

Diagnostic Levels
=================

LSP shows different levels of issues:

- **Error** - Code that won't run
- **Warning** - Likely issues
- **Info** - Informational
- **Hint** - Suggestions

Filter which to show:

.. code-block:: lua

    vim.diagnostic.config({
        severity = {
            min = vim.diagnostic.severity.WARNING,  -- Hide hints
        }
    })

LSP Completion Setup
====================

Code completion settings:

.. code-block:: lua

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

Enables:

- Snippet completion
- Multi-line completions
- Automatic parameter insertion

on_attach Hook
==============

The ``on_attach`` function runs when LSP connects:

.. code-block:: lua

    local function on_attach(client, bufnr)
        -- Set up keybindings here
        -- Customize per-buffer settings
    end

Use this to:

- Set keybindings (already done in which-key.lua)
- Disable features per buffer
- Configure inlay hints
- Set up format-on-save

**Example: Enable inlay hints**:

.. code-block:: lua

    function on_attach(client, bufnr)
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr })
        end
    end

Multiple Language Servers
==========================

Add support for other languages:

**Go**:

.. code-block:: lua

    lsp.gopls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
    })

**Rust**:

.. code-block:: lua

    lsp.rust_analyzer.setup({
        capabilities = capabilities,
        on_attach = on_attach,
    })

**TypeScript**:

.. code-block:: lua

    lsp.tsserver.setup({
        capabilities = capabilities,
        on_attach = on_attach,
    })

**JavaScript**:

.. code-block:: lua

    lsp.eslint.setup({
        capabilities = capabilities,
        on_attach = on_attach,
    })

Common LSP Capabilities
=======================

Capabilities define what features LSP can use:

.. code-block:: lua

    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Code completion
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    -- Folding
    capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
    }

Advanced Features
=================

**Code Lens** (run tests from editor):

.. code-block:: lua

    capabilities.textDocument.codeLens = {}

**Inlay Hints** (type annotations):

.. code-block:: lua

    capabilities.inlayHint = {}

**Semantic Tokens** (advanced highlighting):

.. code-block:: lua

    capabilities.textDocument.semanticTokens = {}

Diagnostics Configuration
==========================

Control how diagnostics display:

.. code-block:: lua

    vim.diagnostic.config({
        -- Appearance
        virtual_text = {
            prefix = "●",  -- Use a symbol
            spacing = 4,
        },

        -- Behavior
        update_in_insert = false,
        underline = true,
        signs = true,

        -- Sorting
        severity_sort = true,
    })

Diagnostic Keybindings
======================

Standard keybindings (in which-key.lua):

.. code-block:: lua

    wk.add({
        { "]d", vim.diagnostic.goto_next, desc = "Next diagnostic" },
        { "[d", vim.diagnostic.goto_prev, desc = "Prev diagnostic" },
        { "<leader>d", function() vim.diagnostic.toggle() end, desc = "Toggle diagnostics" },
    })

Hover Configuration
===================

Customize hover information:

.. code-block:: lua

    -- In on_attach
    vim.lsp.buf.hover()  -- Show on 'K'

Hover shows:

- Documentation
- Type information
- Signature
- Source location

LSP Formatting
==============

Format code using LSP:

.. code-block:: lua

    vim.lsp.buf.format({ async = true })

Or integrate with darker:

.. code-block:: lua

    -- In autocmds.lua
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.py",
        callback = function()
            require('darker').format()
        end
    })

Workspace Folders
=================

LSP can track multiple projects:

.. code-block:: lua

    lsp.add_workspace_folder(vim.fn.getcwd())

Useful for monorepos and multi-project setups.

Debugging LSP Issues
====================

**Enable logging**:

.. code-block:: lua

    vim.lsp.set_log_level("debug")

**View logs**:

.. code-block:: bash

    tail ~/.local/share/nvim/lsp.log

**Check status**:

.. code-block:: vim

    :LspInfo

Shows:

- Active servers
- Capabilities
- Configuration

**Restart LSP**:

.. code-block:: vim

    :LspRestart

Disabling LSP Features
======================

Disable specific features:

.. code-block:: lua

    -- Disable semantic highlighting
    client.server_capabilities.semanticTokensProvider = nil

    -- Disable code lens
    client.server_capabilities.codeLensProvider = false

Performance Tuning
==================

**Limit document sync**:

.. code-block:: lua

    -- Sync after delays, not on every keystroke
    settings = {
        textDocumentSync = 2,  -- Incremental
    }

**Exclude large files**:

.. code-block:: lua

    function on_attach(client, bufnr)
        if vim.fn.getfsize(vim.fn.bufname(bufnr)) > 1000000 then
            client.stop()  -- Don't analyze huge files
        end
    end

**Lazy start**:

.. code-block:: lua

    if vim.fn.exists(':LspStart') == 2 then
        vim.cmd.LspStart()
    end

Server Settings Reference
==========================

For Zuban-specific settings, see:

.. code-block:: bash

    ~/.virtualenvs/nvim/bin/pip show zuban

Common settings:

- ``typeCheckingMode`` - "off", "basic", "strict"
- ``diagnosticMode`` - What to report
- ``includeOptionalDependencies`` - Type check optional deps

Server-specific Documentation
=============================

Each language server has its own documentation:

- Zuban: https://github.com/zubanls/zuban
- gopls: https://github.com/golang/tools/tree/master/gopls
- rust-analyzer: https://rust-analyzer.github.io/
- tsserver: https://github.com/Microsoft/TypeScript

Testing LSP Configuration
==========================

After changes:

1. Restart LSP: ``:LspRestart``
2. Open a Python file
3. Check status: ``:LspInfo``
4. Verify features work:
   - Hover with ``K``
   - Go to definition with ``gd``
   - Completions with ``<C-x><C-o>``
5. Check diagnostics

Troubleshooting LSP
===================

**LSP won't start**:

1. Check Python path: ``:LspInfo``
2. Verify Zuban installed: ``pip list | grep zuban``
3. Check logs: ``:LspLog``

**Completions not working**:

1. LSP may be analyzing: Wait a moment
2. Check capabilities: ``:LspInfo``
3. Restart: ``:LspRestart``

**Slow performance**:

1. Check file size - huge files slow LSP
2. Disable unnecessary checks
3. Increase debounce time
4. Profile with ``:LspLog``

**Wrong diagnostics**:

1. Check type checking mode
2. Configure exclusions
3. Verify Python path

See :doc:`troubleshooting` for more solutions.

Summary
=======

LSP configuration is powerful. Key points:

- Zuban is the Python server
- Configure in ``lua/lsp/lsp.lua``
- Set keybindings in ``which-key.lua``
- Use diagnostics config for appearance
- Add servers for other languages
- Tune performance for your workflow
