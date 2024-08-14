local utils = require("utils")

-- [[ Commentstring ]]

vim.bo.commentstring = "// %s" -- %s is the text placeholder

-- [[ Colorcolumn ]]

--- Get the right color column value for typstyle for the current buffer, which is not configurable.
---@return string _ The relevant color column value.
local function get_colorcolumn()
  return "121" -- Correspond to default formatter value
end

-- Display a column ruler at the relevant line length
if
  vim.opt_local.colorcolumn._value == "" -- Don't compute the value several times
  and vim.g.ruler_column_mode == "auto"
  and not utils.buffer.tooling_is_disabled()
then
  vim.opt_local.colorcolumn = get_colorcolumn()
end
