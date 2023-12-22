-- These functions must be used with the `show_condition` option in snippets, they are not suited to
-- the `condition` as they don't support the right parameters for it.

local cond_obj = require("luasnip.extras.conditions")

local M = {}

-- A matched trigger is considered to be everything after the last white space or punctuation mark
-- in the line before cursor (this is true as long as the matched trigger doesn't have white spaces
-- or punctuation marks itself, which is a good assumption as `nvim-cmp` doesn't take them into
-- account when completing).
local matched_trigger_separator_pattern = "[%s%p]"
-- In the following pattern, the first capturing group captures greedily everything until a
-- separator is found (since it's greedy, it will capture everything until the last occurence)
local matched_trigger_pattern = "(.*)" .. matched_trigger_separator_pattern .. "(.*)$"

local function get_treesitter_node(line_to_cursor)
  local _, matched_trigger = string.match(line_to_cursor, matched_trigger_pattern)
  if matched_trigger == nil then
    matched_trigger = ""
  end

  local _, row, col, _, _ = unpack(vim.fn.getcurpos())
  return vim.treesitter.get_node({
    pos = { row - 1, col - #matched_trigger - 1 },
  })
end

-- Condition determining wether a snippet is in actual code or not, using treesitter.
local function is_in_code(line_to_cursor)
  local is_treesitter_parsable, node = pcall(get_treesitter_node, line_to_cursor)
  if is_treesitter_parsable then
    return node
      and not (
        node:type() == "comment"
        or node:type() == "comment_content"
        or node:type() == "string"
        or node:type() == "string_content"
      )
  else
    return false
  end
end
M.is_in_code = cond_obj.make_condition(is_in_code)

-- Condition determining wether a snippet is in a comment or not, using treesitter.
local function is_in_comment(line_to_cursor)
  local is_treesitter_parsable, node = pcall(get_treesitter_node, line_to_cursor)
  if is_treesitter_parsable then
    return node and (node:type() == "comment" or node:type() == "comment_content")
  else
    return false
  end
end
M.is_in_comment = cond_obj.make_condition(is_in_comment)

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
