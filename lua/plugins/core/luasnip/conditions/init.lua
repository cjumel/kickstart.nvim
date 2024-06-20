-- Define custom conditions & related utilities used throughout various custom snippets.

local M = {}

M.line_begin = require("plugins.core.luasnip.conditions.line_begin")
M.is_in_code = require("plugins.core.luasnip.conditions.is_in_code")
M.is_in_comment = require("plugins.core.luasnip.conditions.is_in_comment")
M.utils = require("plugins.core.luasnip.conditions.utils")

return M
