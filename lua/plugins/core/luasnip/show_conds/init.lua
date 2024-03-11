-- These functions must be used with the `show_condition` option in snippets, they are not suited to
-- the `condition` as they don't support the right parameters for it.

local M = {}

M.project = require("plugins.core.luasnip.show_conds.project")
M.oil = require("plugins.core.luasnip.show_conds.oil")
M.ts = require("plugins.core.luasnip.show_conds.treesitter")

return M
