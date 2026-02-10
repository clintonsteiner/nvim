==================
Project Philosophy
==================

The principles and design decisions behind this configuration.

Core Principles
===============

1. **Minimal** - Only essential plugins and features
2. **Pragmatic** - Focus on what actually helps development
3. **Python-first** - Optimized for Python workflows
4. **Fast** - Quick startup and responsive editing
5. **Maintainable** - Clean, understandable code
6. **Learnable** - Not too magical, easy to customize

Why These Principles?
======================

**Minimal and Pragmatic**

A configuration with 50 plugins will have:

- Slow startup time
- Complex interactions
- Hard to maintain
- Features you never use

Better to have 5 well-chosen plugins that you actually use.

**Python-first**

While the configuration works with many languages, it's optimized for Python because:

- Python development has unique needs (virtual environments, testing, formatting)
- Python is a general-purpose language suitable for many projects
- Most developers working in Python benefit from Python-specific tools

**Fast Responsiveness**

Developers spend hours in their editor. It should feel fast:

- Startup time under 100ms
- Instant response to keypresses
- No lag when editing

**Maintainable Code**

A configuration should be:

- Easy to understand
- Easy to modify
- Easy to extend
- Not cryptic one-liners

**Learnable**

A new user should be able to:

- Understand the basic structure
- Make simple customizations
- Learn incrementally
- Not need to read hundreds of lines

Design Decisions
================

Plugin Selection
----------------

**Why FZF instead of file browser plugins?**

- Faster than directory trees
- Works better with large projects
- Familiar to CLI users
- Integrates with git naturally

**Why minimal plugins?**

Every plugin has a cost:

- Startup time
- Memory usage
- Potential conflicts
- Maintenance burden

Each plugin must justify its existence.

**Why no plugin manager UI?**

Plugin managers add complexity. vim-plug is simpler:

- Just call ``:PlugInstall``
- Clear what's happening
- Easy to understand
- No abstraction layers

LSP Over Language-Specific Plugins
-----------------------------------

Instead of using vim-lsp, coc.nvim, or other LSP clients, we use the built-in Neovim LSP:

**Advantages**:

- Built into Neovim 0.5+
- Fast and lightweight
- Standard approach
- Easy to configure
- Works with any LSP server

**Disadvantage**:

- Requires manual setup (but we document it)

Zuban for Python
----------------

We chose Zuban because:

- Written in Rust (fast)
- Good Python support
- Minimal dependencies
- Active development
- Smaller footprint than PyLance or Pylance

Status Line Implementation
--------------------------

Instead of using a plugin (Lualine, airline), we implement a custom status line:

**Why custom?**

- Simpler to understand
- Faster than plugins
- Exactly what we need
- Easy to customize
- No dependencies

**What we lose**:

- No fancy animations
- No theme integration
- Have to maintain it

Trade-off is worth it for simplicity.

No Auto-Completion Plugin
--------------------------

We don't use a completion framework (cmp, vim-complete, etc.) because:

- LSP provides completion via ``<C-x><C-o>``
- Lighter weight
- Less magic
- Still functional

Users can add their favorite completion plugin if desired.

Focus on Built-in Features
---------------------------

We leverage Neovim's built-in features:

- Native LSP client
- Built-in terminal (fterm)
- Native statusline
- Native diagnostic display
- Native completion

This makes the config faster and easier to maintain.

Python Development Philosophy
==============================

**Testing**

Tests are important:

- ``<leader>t`` to run current file tests
- ``<leader>T`` to run specific test
- Fast feedback loop
- Catch errors early

**Code Quality**

Multiple tools for quality:

- **Ruff** - Linting (what's wrong)
- **Darker** - Formatting (consistency)
- **Zuban** - Type checking (correctness)

**Virtual Environments**

Separate Python environment for Neovim tools:

- Doesn't conflict with project environments
- Isolated from system Python
- Easy to update tools
- Reproducible setup

Simplicity Over Features
=========================

**Example: Not using a file browser plugin**

A file browser plugin might offer:

- Tree view of all files
- Delete/rename via UI
- Bookmarks
- Custom icons

But FZF offers:

- Fast file search (opens in milliseconds)
- Filter by name
- Preview of contents
- Integration with git

FZF is actually better for 90% of use cases.

**Example: Custom status line over plugin**

A status line plugin might offer:

- 50 configuration options
- Theme support
- Animations
- Complex layouts

Our status line:

- Shows what matters (file, location, git, diagnostics)
- 30 lines of code
- Instant to load
- Easy to customize

Less is more.

No IDE-like Features
====================

This is an editor, not an IDE. We don't try to replicate:

- Project file trees
- Debug UI
- Test runners with buttons
- Build systems

If you want those, use an IDE. If you want a fast, lightweight editor, use this.

**Why?**

- You can use command-line tools instead
- Neovim is better as a text editor than a fake IDE
- Adding IDE features makes it slow and complex

Customization Philosophy
========================

The configuration is a starting point, not a straitjacket.

**Easy to modify**:

- Every setting is documented
- Configuration is organized by feature
- You can change almost anything
- Clear patterns to follow

**Add what you need**:

- Don't like FZF? Replace it with telescope
- Want more completion? Add nvim-cmp
- Need specific features? Extend it

**Don't modify what works**:

- If feature works well, leave it
- Unnecessary changes introduce bugs
- Keep things simple

User-Centric Design
===================

This configuration prioritizes the user:

- **Quick to install** - One command sets everything up
- **Easy to learn** - Clear documentation and structure
- **Fast to use** - LSP and FZF are quick
- **Safe to modify** - Well-organized code
- **Reliable** - Thoroughly tested
- **Helpful** - Extensive documentation

Trade-offs
==========

Every design decision has trade-offs:

**Minimal plugins**

- Pro: Fast, simple, maintainable
- Con: Some features require manual setup

**Python-first**

- Pro: Great for Python developers
- Con: Might not be ideal for Ruby/Go/JS developers

**Custom status line**

- Pro: Fast, understandable
- Con: Have to maintain it, no themes

**FZF over file browser**

- Pro: Fast, powerful
- Con: Different paradigm, needs typing

These are conscious choices. Alternatives exist, but we chose the trade-offs that best serve the principles.

Not for Everyone
================

This configuration is great for:

- Python developers
- Command-line oriented users
- People who like minimal, fast tools
- Users who want to understand their config
- Developers optimizing for productivity

It's not ideal if you want:

- An IDE-like experience
- GUI file browser
- Built-in debugger
- Point-and-click customization
- Maximum features

**That's okay!** There are other Neovim configs better suited to those needs.

Maintenance Philosophy
======================

**Minimal dependencies**

- Keep external dependencies low
- Prefer built-in features
- Easier to maintain long-term
- Less chance of breakage

**Small codebase**

- Configuration is ~500 lines of Lua
- Easy to understand
- Easy to modify
- Easy to maintain

**Clear documentation**

- Every feature is documented
- Every plugin is explained
- Common tasks have guides
- Troubleshooting guide provided

**Responsive to issues**

- Issues get prompt attention
- Users' problems matter
- Bugs get fixed
- Features get documented

Community
=========

The philosophy extends to community:

- **Respectful** - Treat users with respect
- **Helpful** - Help people get set up
- **Open** - Listen to feedback
- **Stable** - Don't break things unnecessarily

**Contributing**

If you want to contribute:

- Follow the principles above
- Keep changes minimal and focused
- Write clear commit messages
- Update documentation
- Test before submitting

**Using as a starting point**

Don't need to use this exact config?

- Fork it
- Modify it
- Make it your own
- Share what you learn

License and Sharing
===================

This is a personal configuration shared publicly.

**Feel free to**:

- Use as-is
- Customize for your needs
- Share with others
- Build on top of it

**License**: All code is provided as-is. See LICENSE file.

Evolution
=========

This configuration will evolve, but it will always:

- Stay minimal
- Prioritize speed
- Focus on Python development
- Maintain simplicity
- Document thoroughly

**Version compatibility**:

- Targets Neovim 0.11+ (modern features)
- May drop support for old versions
- Breaking changes documented
- Migration guides provided

Why This Matters
================

Good tools matter. A well-designed editor:

- Saves time through efficiency
- Reduces cognitive load
- Minimizes frustration
- Enables flow state
- Respects your time

This configuration is built with those goals in mind.

The goal isn't a perfect configuration (doesn't exist), but a good one that:

- Works well for Python development
- Respects your time
- Doesn't get in the way
- Is easy to understand
- Can be made your own

That's the philosophy.
