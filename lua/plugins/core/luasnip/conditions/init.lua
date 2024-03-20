-- These functions must be used with the `show_condition` option in snippets, not `condition`

local M = {}

M.project = require("plugins.core.luasnip.conditions.project")
M.ts = require("plugins.core.luasnip.conditions.treesitter")

return M
