local luasnip_conditions = require("luasnip.extras.conditions")

local matched_trigger_pattern = require("plugins.core.luasnip.conditions.utils").matched_trigger_pattern

--- Check wether a snippet suggestion is at the beginning of a line or not.
---@param line_to_cursor string The current line up to the current cursor position.
---@return boolean check Whether the snippet is at the beginning of a line or not.
local function line_begin_function(line_to_cursor)
  local before_matched_trigger, _ = string.match(line_to_cursor, matched_trigger_pattern)
  if before_matched_trigger == nil then
    before_matched_trigger = ""
  end
  return string.match(before_matched_trigger, "^%s*$") ~= nil
end
local line_begin_condition = luasnip_conditions.make_condition(line_begin_function)

return line_begin_condition
