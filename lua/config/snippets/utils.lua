local M = {}

--- Fix the `line_to_cursor` parameter when using snippets with blink.cmp, where the last character is missing.
---@param line_to_cursor string
---@return string
function M.fix_line_to_cursor(line_to_cursor)
  local line = vim.api.nvim_get_current_line()
  return string.sub(line, 1, #line_to_cursor + 1)
end

-- During a completion, the matched trigger is the small word part being typed and leading to matching suggestions.
-- Here, we consider it to be everything after the last white space or punctuation mark in the current line before the
-- cursor (this is true as long as the matched trigger doesn't have white spaces or punctuation marks itself).
local separator_pattern = "[%s%p]"
-- The matched trigger pattern can be used to filter out the matched trigger from the current line. In the following
-- pattern, the first capturing group captures greedily everything until a separator is found (since it's greedy, it
-- will capture everything until the last occurence).
local matched_trigger_pattern = "(.*)" .. separator_pattern .. "(.*)$"

--- Output the current line up until the beginning of the matched trigger. This will include white spaces if any.
---@param line_to_cursor string
---@return string
function M.get_line_to_trigger(line_to_cursor)
  -- We can't use the value of `_` below as it capture what's before `matched_trigger` except for the last character
  local _, matched_trigger = string.match(line_to_cursor, matched_trigger_pattern)
  if matched_trigger == nil then -- This happens when typing the first word of a line
    return ""
  end
  return string.sub(line_to_cursor, 1, #line_to_cursor - #matched_trigger)
end

--- Output the Treesitter node at the position before the matched trigger.
---@param line_to_cursor string
---@return TSNode|nil node
function M.get_treesitter_node_at_trigger(line_to_cursor)
  -- We can't use the value of `_` below as it capture what's before `matched_trigger` except for the last character
  local _, matched_trigger = string.match(line_to_cursor, matched_trigger_pattern)
  if matched_trigger == nil then -- This happens when typing the first word of a line
    matched_trigger = ""
  end
  local _, row, col, _, _ = unpack(vim.fn.getcurpos())
  local node = vim.treesitter.get_node({ pos = { row - 1, col - #matched_trigger - 1 } })
  return node
end

return M
