-- These functions must be used with the `show_condition` option in snippets, not `condition`

local cond_obj = require("luasnip.extras.conditions")

local matched_trigger_pattern = require("plugins.core.luasnip.conditions.matched_trigger_pattern")

local M = {}

M.ts = require("plugins.core.luasnip.conditions.treesitter")

-- Condition determining wether a snippet is at the beginning of a line or not.
local function line_begin(line_to_cursor)
  local before_matched_trigger, _ = string.match(line_to_cursor, matched_trigger_pattern)
  if before_matched_trigger == nil then
    before_matched_trigger = ""
  end

  return string.match(before_matched_trigger, "^%s*$") ~= nil
end
M.line_begin = cond_obj.make_condition(line_begin)

return M
