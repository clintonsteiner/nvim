===================
Suggested Workflows
===================

This page is optimized for speed and low mental overhead.
If you only remember one thing: use the **Start Here** flow.

Start Here (Default Loop)
=========================

1. Open and pin working files:

   - ``<leader>of`` open files
   - ``<leader>ja`` add current file to Harpoon
   - ``<leader>j1``..``<leader>j4`` jump pinned files

2. Keep structure visible:

   - ``<leader>lo`` toggle outline (Aerial)
   - Breadcrumbs in winbar show your current symbol path

3. Validate while coding:

   - Save file (auto background tests run for supported filetypes)
   - ``<leader>mn`` run nearest test (Go/Python)
   - ``<leader>mt`` run test task
   - ``<leader>ml`` run lint task
   - ``<leader>mb`` run build task

4. Handle failures fast:

   - Quickfix opens automatically on failures
   - ``<leader>qo`` open quickfix
   - ``<leader>qc`` close quickfix

5. Commit/rebase:

   - ``<leader>gRm`` rebase on top of ``origin/master``
   - ``<leader>gRc`` continue when conflicts are resolved

Daily Coding Loop
=================

1. Open project files and mark hotspots:

   - ``<leader>of`` open files
   - ``<leader>ja`` add current file to Harpoon
   - ``<leader>j1``..``<leader>j4`` jump marked files
   - ``<leader>jn`` / ``<leader>jp`` cycle marks

2. Navigate symbols quickly:

   - ``<leader>lo`` toggle Aerial outline
   - ``<leader>lO`` toggle Aerial nav window
   - Winbar breadcrumbs show current symbol context

3. Code + validate continuously:

   - Save file to trigger background auto test runner
   - ``<leader>mn`` run nearest test quickly
   - ``<leader>mt`` run project test task
   - ``<leader>ml`` run lint task
   - ``<leader>mb`` run build task
   - Failed runs open quickfix automatically, success closes it
   - ``<leader>qo`` open quickfix, ``<leader>qc`` close quickfix

Stuck/Debug Loop
================

1. Find exactly what broke:

   - ``<leader>qo`` open quickfix
   - ``]q`` / ``[q`` move between failures
   - ``<leader>xo`` show last auto-test output

2. Inspect nearby code faster:

   - ``<leader>lo`` outline
   - ``<leader>ff`` treesitter functions
   - ``<leader>rg`` project search

3. Fix and verify:

   - write fix, save
   - ``<leader>tr`` rerun auto test now
   - ``<leader>mt`` full test task if needed

Go Workflow
===========

1. Test and iterate:

   - ``<leader>Gt`` test all packages (``go test ./...``)
   - ``<leader>Gp`` test current package
   - ``<leader>Gz`` test function under cursor
   - ``<leader>Gb`` run package benchmarks

2. Keep project clean:

   - ``<leader>Gv`` ``go vet ./...``
   - ``<leader>Gm`` ``go mod tidy``
   - ``<leader>GF`` ``go fmt ./...``

3. Use snippets:

   - ``iferr`` standard error guard
   - ``ttest`` table-driven test skeleton
   - ``ctx`` context timeout boilerplate

Python Workflow
===============

1. Fast test runs:

   - ``<leader>py`` run current file
   - ``<leader>pz`` run test under cursor
   - ``<leader>pc`` file coverage

2. Refactor safely:

   - ``<leader>ln`` incremental rename
   - ``<leader>Ra`` refactor picker

3. Use snippets:

   - ``pytestf`` basic pytest function
   - ``pytestp`` parametrize test template
   - ``tryx`` try/except skeleton

Git Rebase On Top of Master
===========================

1. Start rebase:

   - ``<leader>gRm`` fetch + rebase onto ``origin/master`` (fallback ``master``)
   - ``<leader>gF`` fetch ``upstream`` (fork workflow)

2. Resolve conflicts:

   - ``<leader>gRl`` list unresolved files in quickfix
   - ``<leader>gRo`` use base branch version for current file
   - ``<leader>gRt`` use current commit version for current file
   - ``<leader>gRA`` mark current file resolved (``git add``)
   - ``<leader>gRd`` open Diffview

3. Finish flow:

   - ``<leader>gRc`` continue
   - ``<leader>gRs`` skip current patch
   - ``<leader>gRa`` abort rebase

Refactor Workflow
=================

1. Rename safely:

   - ``<leader>ln`` incremental rename
   - ``<leader>lN`` prompt-based rename

2. Structural refactors:

   - ``<leader>Ra`` refactor picker
   - Visual select then ``<leader>Re`` extract function
   - Visual select then ``<leader>Rv`` extract variable

3. Verify:

   - ``<leader>mn`` nearest test
   - ``<leader>mt`` tests
   - ``<leader>ml`` lint

tmux + Neovim
=============

- ``<C-h/j/k/l>`` navigate between tmux and Neovim panes
- Keep Harpoon marks for your active files and jump without pane churn
- Use Aerial in a side window for symbol-level movement while coding in the main pane

Memory Cheat Sheet
==================

- ``<leader>j...`` file jumps (Harpoon)
- ``<leader>l...`` language/LSP actions
- ``<leader>m...`` test/lint/build tasks
- ``<leader>gR...`` rebase flow
- ``<leader>q...`` quickfix

Project Overrides
=================

1. Generate template:

   - ``:ProjectInit`` creates ``.nvim/tasks.lua``

2. Trust overrides for current repo:

   - ``:ProjectOverrideTrust``

3. Typical customization:

   - set ``test``, ``lint``, ``build`` commands per language or default
