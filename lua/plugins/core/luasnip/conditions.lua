-- Define custom conditions & related utilities used throughout various custom snippets.

local ls_conditions = require("luasnip.extras.conditions")
local ls_conditions_show = require("luasnip.extras.conditions.show")

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
local matched_trigger_pattern = "(.*)" .. separator_pattern .. "(.*)$"

--- Get the Treesitter node at the position before the matched trigger. This is useful in conditions, to reason over
--- the actual Treesitter node of interest instead of the one after the matched trigger (at the cursor position).
---@param line_to_cursor string The current line up to the current cursor position.
---@return TSNode|nil node The Treesitter node at the position before the matched trigger.
local function get_treesitter_node(line_to_cursor)
  local _, matched_trigger = string.match(line_to_cursor, matched_trigger_pattern)
  if matched_trigger == nil then
    matched_trigger = ""
  end

  local _, row, col, _, _ = unpack(vim.fn.getcurpos())
  local node = vim.treesitter.get_node({ pos = { row - 1, col - #matched_trigger - 1 } })
  return node
end

--- Check wether the cursor is in the first line of the file or not.
---@return boolean
local function first_line()
  local _, row, _, _, _ = unpack(vim.fn.getcurpos())
  return row == 1
end
local first_line_condition = ls_conditions.make_condition(first_line)
M.first_line = first_line_condition

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
local line_begin_condition = ls_conditions.make_condition(line_begin_function)
M.line_begin = line_begin_condition

local excluded_node_types = { -- Treesitter nodes considered to be not in actual code
  "comment",
  "comment_content",
  "string",
  "string_start",
  "string_content",
}

--- Check wether a snippet suggestion is in actual code or not (e.g. in a string or in a comment), using Treesitter.
---@param line_to_cursor string The current line up to the current cursor position.
---@return boolean check Whether the cursor is in actual code or not.
local function is_in_code_function(line_to_cursor)
  local is_treesitter_parsable_, node = pcall(get_treesitter_node, line_to_cursor)
  if not is_treesitter_parsable_ then -- Treesitter is not available or the buffer is not parsable
    return false
  end
  if not node then -- E.g. very beginning of the buffer
    return true
  end

  return not vim.tbl_contains(excluded_node_types, node:type())
end
local is_in_code_condition = ls_conditions.make_condition(is_in_code_function)
M.is_in_code = is_in_code_condition
M.is_in_code_empty_line = is_in_code_condition * line_begin_condition * ls_conditions_show.line_end
M.is_in_code_inline = is_in_code_condition * -line_begin_condition

local comment_node_types = {
  "comment",
  "comment_content",
}

--- Check wether a snippet suggestion is in a comment or not, using Treesitter.
---@param line_to_cursor string The current line up to the current cursor position.
---@return boolean check Whether the cursor is in a comment or not.
local function is_in_comment_function(line_to_cursor)
  local is_treesitter_parsable_, node = pcall(get_treesitter_node, line_to_cursor)
  if not is_treesitter_parsable_ then -- Treesitter is not available or the buffer is not parsable
    return false
  end
  if not node then -- E.g. very beginning of the buffer
    return false
  end
  return vim.tbl_contains(comment_node_types, node:type())
end
local is_in_comment_condition = ls_conditions.make_condition(is_in_comment_function)
M.is_in_comment = is_in_comment_condition

return M
