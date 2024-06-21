local ls_conditions = require("luasnip.extras.conditions")

--- Check wether the cursor is in the first line of the file or not.
---@return boolean
local function first_line()
  local _, row, _, _, _ = unpack(vim.fn.getcurpos())
  return row == 1
end
local first_line_condition = ls_conditions.make_condition(first_line)

return first_line_condition
