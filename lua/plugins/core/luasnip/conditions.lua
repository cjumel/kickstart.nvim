-- Define custom conditions and related utilities used throughout the various snippets, similarly to
-- `luasnip.extras.conditions` and `luasnip.extras.conditions.show`.

local ls_conds = require("luasnip.extras.conditions")

local M = {}

-- During a completion suggestion, the trigger is the string that triggered the suggestion (typically a few letters).
-- Here, a matched trigger is considered to be everything after the last white space or punctuation mark in the current
--  line, before the cursor (this is true as long as the matched trigger doesn't have white spaces or punctuation marks
--  itself, which is a good assumption as `nvim-cmp` doesn't take them into account when completing).
local separator_pattern = "[%s%p]"
-- The matched trigger pattern can be used to filter out the matched trigger from the current line when evaluating show
--  conditions.
-- In the following pattern, the first capturing group captures greedily everything until a separator is found (since
--  it's greedy, it will capture everything until the last occurence).
local matched_trigger_pattern = "(.*)" .. separator_pattern .. "(.*)$"

--- Output the current line up until the matched trigger (typically the word which is being typed) but without it. This
--- will include white spaces if any.
---@param line_to_cursor string The current line up to the current cursor position, including the matched trigger.
---@return string
local function get_line_to_trigger(line_to_cursor)
  -- We can't use the value of `_` below as it capture what's before `matched_trigger` except for the last character
  local _, matched_trigger = string.match(line_to_cursor, matched_trigger_pattern)
  if matched_trigger == nil then -- Happen while typing the first word of a line
    return ""
  end
  return string.sub(line_to_cursor, 1, #line_to_cursor - #matched_trigger)
end

--- Get the Treesitter node at the position before the matched trigger. This is useful in conditions, to reason over
--- the actual Treesitter node of interest instead of the one after the matched trigger (at the cursor position).
---@param line_to_cursor string The current line up to the current cursor position, including the matched trigger.
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

--- Condition making sure the current Treesitter node's type is included in the provided node types.
--- @param node_types string[] The node types to be included.
--- @return table
M.make_treesitter_node_inclusion_condition = function(node_types)
  return ls_conds.make_condition(function(line_to_cursor)
    local is_treesitter_parsable_, node = pcall(get_treesitter_node, line_to_cursor)
    if not is_treesitter_parsable_ then -- Treesitter is not available or the buffer is not parsable
      return false
    end
    if not node then -- E.g. very beginning of the buffer
      return false
    end
    return vim.tbl_contains(node_types, node:type())
  end)
end

--- Condition making sure the current Treesitter node's type is excluded from the provided node types.
--- @param node_types string[] The node types to be excluded from.
--- @return table
M.make_treesitter_node_exclusion_condition = function(node_types)
  return ls_conds.make_condition(function(line_to_cursor)
    local is_treesitter_parsable_, node = pcall(get_treesitter_node, line_to_cursor)
    if not is_treesitter_parsable_ then -- Treesitter is not available or the buffer is not parsable
      return false
    end
    if not node then -- E.g. very beginning of the buffer
      return true
    end
    return not vim.tbl_contains(node_types, node:type())
  end)
end

--- Condition making sure the current Treesitter node's ancestor types don't match the provided node types.
--- @param node_types string[] The ancestor node types to not match, bottom to top.
--- @return table
M.make_treesitter_node_ancestors_exclusion_condition = function(node_types)
  return ls_conds.make_condition(function(line_to_cursor)
    local is_treesitter_parsable_, node = pcall(get_treesitter_node, line_to_cursor)
    if not is_treesitter_parsable_ then -- Treesitter is not available or the buffer is not parsable
      return false
    end
    if not node then -- E.g. very beginning of the buffer
      return true
    end

    for _, node_type in ipairs(node_types) do
      if node == nil or node:type() ~= node_type then
        return true
      end
      node = node:parent()
    end
    return false
  end)
end

--- Condition making sure the current Treesitter node's ancestor types match the provided node types.
--- @param node_types string[] The ancestor node types to match, bottom to top.
--- @return table
M.make_treesitter_node_ancestors_inclusion_condition = function(node_types)
  return ls_conds.make_condition(function(line_to_cursor)
    local is_treesitter_parsable_, node = pcall(get_treesitter_node, line_to_cursor)
    if not is_treesitter_parsable_ then -- Treesitter is not available or the buffer is not parsable
      return false
    end
    if not node then -- E.g. very beginning of the buffer
      return false
    end

    for _, node_type in ipairs(node_types) do
      if node == nil or node:type() ~= node_type then
        return false
      end
      node = node:parent()
    end
    return true
  end)
end

--- Check wether the cursor is in the first line of the file or not.
---@return boolean
local function first_line()
  local _, row, _, _, _ = unpack(vim.fn.getcurpos())
  return row == 1
end
local first_line_condition = ls_conds.make_condition(first_line)
M.first_line = first_line_condition

--- Check wether a snippet suggestion is at the beginning of a line or not.
---@param line_to_cursor string The current line up to the current cursor position, including the matched trigger.
---@return boolean
local function line_begin_function(line_to_cursor)
  local line_to_trigger = get_line_to_trigger(line_to_cursor)
  return string.match(line_to_trigger, "^%s*$") ~= nil
end
local line_begin_condition = ls_conds.make_condition(line_begin_function)
M.line_begin = line_begin_condition

M.make_strict_prefix_condition = function(prefix)
  return ls_conds.make_condition(function(line_to_cursor)
    local line_to_trigger = get_line_to_trigger(line_to_cursor)
    return line_to_trigger == prefix
  end)
end

M.make_prefix_condition = function(prefix)
  return ls_conds.make_condition(function(line_to_cursor)
    local line_to_trigger = get_line_to_trigger(line_to_cursor)
    local line_to_trigger_end = string.sub(line_to_trigger, #line_to_trigger - #prefix + 1, #line_to_trigger)
    if line_to_trigger_end ~= prefix then
      return false
    end
    local line_to_trigger_start = string.sub(line_to_trigger, 1, #line_to_trigger - #prefix)
    return string.match(line_to_trigger_start, "^%s*$") ~= nil -- Like in line_begin_function
  end)
end

--- Check whether a snippet suggestion is at the beginning of a comment or not. This does not check properly if the
--- suggestion is actually in a comment or not, though, so this must be done as well before hand. Besides, this will
--- only work for languages where the comments are introduced only with a prefix, like Python ("# ") or Lua ("-- "),
--- but not for Markdown, for instance ("<!-- " and "--!>").
---@param line_to_cursor string The current line up to the current cursor position, including the matched trigger.
---@return boolean
local function is_comment_start_function(line_to_cursor)
  local commentstring_suffix = string.sub(vim.bo.commentstring, #vim.bo.commentstring - 1, #vim.bo.commentstring)
  if commentstring_suffix ~= "%s" then
    return false
  end
  local commentstring_prefix = string.sub(vim.bo.commentstring, 1, #vim.bo.commentstring - 2)

  local line_to_trigger = get_line_to_trigger(line_to_cursor)
  local line_to_trigger_end =
    string.sub(line_to_trigger, #line_to_trigger - #commentstring_prefix + 1, #line_to_trigger)
  return line_to_trigger_end == commentstring_prefix
end
local is_comment_start_condition = ls_conds.make_condition(is_comment_start_function)
M.is_comment_start = is_comment_start_condition

return M
