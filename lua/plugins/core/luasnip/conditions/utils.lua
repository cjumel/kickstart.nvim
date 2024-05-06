-- Utilities for Luasnip custom conditions.

local M = {}

-- During a completion suggestion, the trigger is the string that triggered the suggestion (typically a few letters).
-- Here, a matched trigger is considered to be everything after the last white space or punctuation mark in the current
-- line, before the cursor (this is true as long as the matched trigger doesn't have white spaces or punctuation marks
-- itself, which is a good assumption as `nvim-cmp` doesn't take them into account when completing).
local separator_pattern = "[%s%p]"
-- The matched trigger pattern can be used to filter out the matched trigger from the current line when evaluating show
-- conditions.
-- In the following pattern, the first capturing group captures greedily everything until a separator is found (since
-- it's greedy, it will capture everything until the last occurence)
M.matched_trigger_pattern = "(.*)" .. separator_pattern .. "(.*)$"

--- Get the Treesitter node at the position before the matched trigger. This is useful in conditions, to reason over
--- the actual Treesitter node of interest instead of the one after the matched trigger (at the cursor position).
---@param line_to_cursor string The current line up to the current cursor position.
---@return TSNode|nil node The Treesitter node at the position before the matched trigger.
function M.get_treesitter_node(line_to_cursor)
  local _, matched_trigger = string.match(line_to_cursor, M.matched_trigger_pattern)
  if matched_trigger == nil then
    matched_trigger = ""
  end

  local _, row, col, _, _ = unpack(vim.fn.getcurpos())
  local node = vim.treesitter.get_node({ pos = { row - 1, col - #matched_trigger - 1 } })
  return node
end

return M
