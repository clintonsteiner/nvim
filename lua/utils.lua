---Core utility modules
local M = {}

M.core = require("utils.core")
M.treesitter = require("utils.treesitter")
M.python = require("utils.python")
M.go = require("utils.go")
M.statusline = require("utils.statusline")
M.lsp = require("utils.lsp")

return M
