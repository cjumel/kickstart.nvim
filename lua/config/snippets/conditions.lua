local ls_conds = require("luasnip.extras.conditions")
local snippet_utils = require("config.snippets.utils")

local M = {}

---@param line_to_cursor string
---@return boolean
local function line_begin_function(line_to_cursor)
  -- This only work with a `min_keyword_length` greater than 0
  local line_to_trigger = snippet_utils.get_line_to_trigger(line_to_cursor)
  return string.match(line_to_trigger, "^%s*$") ~= nil
end
M.line_begin = ls_conds.make_condition(line_begin_function)

---@param line_to_cursor string
---@return boolean
local function line_end_function(line_to_cursor)
  local line = vim.api.nvim_get_current_line()
  -- With blink.cmp, `line_to_cursor` does not include the character under the cursor
  return line_to_cursor == line:sub(1, -2)
end
M.line_end = ls_conds.make_condition(line_end_function)

---@return boolean
local function first_line_function()
  local _, row, _, _, _ = unpack(vim.fn.getcurpos())
  return row == 1
end
M.first_line = ls_conds.make_condition(first_line_function)

---@param line_to_cursor string
---@return boolean
local function is_comment_start_function(line_to_cursor)
  local commentstring_suffix = string.sub(vim.bo.commentstring, #vim.bo.commentstring - 1, #vim.bo.commentstring)
  if commentstring_suffix ~= "%s" then
    return false
  end
  local commentstring_prefix = string.sub(vim.bo.commentstring, 1, #vim.bo.commentstring - 2)
  local line_to_trigger = snippet_utils.get_line_to_trigger(line_to_cursor)
  local line_to_trigger_end =
    string.sub(line_to_trigger, #line_to_trigger - #commentstring_prefix + 1, #line_to_trigger)
  return line_to_trigger_end == commentstring_prefix
end
M.comment_start = ls_conds.make_condition(is_comment_start_function)

---@param prefix string
---@return table
M.make_prefix_condition = function(prefix)
  return ls_conds.make_condition(function(line_to_cursor)
    local line_to_trigger = snippet_utils.get_line_to_trigger(line_to_cursor)
    local line_to_trigger_end = string.sub(line_to_trigger, #line_to_trigger - #prefix + 1, #line_to_trigger)
    if line_to_trigger_end ~= prefix then
      return false
    end
    local line_to_trigger_start = string.sub(line_to_trigger, 1, #line_to_trigger - #prefix)
    return string.match(line_to_trigger_start, "^%s*$") ~= nil -- Like in line_begin_function
  end)
end

---@param prefix string
---@return table
M.make_strict_prefix_condition = function(prefix)
  return ls_conds.make_condition(function(line_to_cursor)
    local line_to_trigger = snippet_utils.get_line_to_trigger(line_to_cursor)
    return line_to_trigger == prefix
  end)
end

---@param node_types string[]
---@return table
M.make_ts_node_in_condition = function(node_types)
  return ls_conds.make_condition(function(line_to_cursor)
    local is_treesitter_parsable_, node = pcall(snippet_utils.get_treesitter_node_at_trigger, line_to_cursor)
    if not is_treesitter_parsable_ then -- Treesitter is not available or the buffer is not parsable
      return false
    end
    if not node then -- E.g. very beginning of the buffer
      return false
    end
    return vim.tbl_contains(node_types, node:type())
  end)
end

---@param node_types string[]
---@return table
M.make_ts_node_not_in_condition = function(node_types)
  return ls_conds.make_condition(function(line_to_cursor)
    local is_treesitter_parsable_, node = pcall(snippet_utils.get_treesitter_node_at_trigger, line_to_cursor)
    if not is_treesitter_parsable_ then -- Treesitter is not available or the buffer is not parsable
      return false
    end
    if not node then -- E.g. very beginning of the buffer
      return true
    end
    return not vim.tbl_contains(node_types, node:type())
  end)
end

return M
