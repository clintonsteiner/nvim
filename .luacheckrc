-- Neovim configuration luacheck configuration
globals = {
    "vim",  -- Neovim global API
}

-- Allow defining globals in config files
allow_defined_top_level = true

-- Max line length (existing codebase uses long lines)
max_line_length = false

-- Ignore specific warnings
ignore = {
    "111",  -- setting non-standard global variable
    "421",  -- shadowing local variable
    "631",  -- line is too long
}
