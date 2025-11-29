local ls_conds = require("luasnip.extras.conditions")
local snippet_utils = require("config.snippets.utils")

local M = {}

M.line_begin = ls_conds.make_condition(function(line_to_cursor)
  line_to_cursor = snippet_utils.fix_line_to_cursor(line_to_cursor)
  local line_to_trigger = snippet_utils.get_line_to_trigger(line_to_cursor)
  return string.match(line_to_trigger, "^%s*$") ~= nil
end)

M.line_end = ls_conds.make_condition(function(line_to_cursor)
  line_to_cursor = snippet_utils.fix_line_to_cursor(line_to_cursor)
  local line = vim.api.nvim_get_current_line()
  return line_to_cursor == line
end)

M.comment_start = ls_conds.make_condition(function(line_to_cursor)
  line_to_cursor = snippet_utils.fix_line_to_cursor(line_to_cursor)
  local commentstring_suffix = string.sub(vim.bo.commentstring, #vim.bo.commentstring - 1, #vim.bo.commentstring)
  if commentstring_suffix ~= "%s" then
    return false
  end
  local commentstring_prefix = string.sub(vim.bo.commentstring, 1, #vim.bo.commentstring - 2)
  local line_to_trigger = snippet_utils.get_line_to_trigger(line_to_cursor)
  local line_to_trigger_end =
    string.sub(line_to_trigger, #line_to_trigger - #commentstring_prefix + 1, #line_to_trigger)
  return line_to_trigger_end == commentstring_prefix
end)

M.get_ts_node_in_condition = function(node_types)
  return ls_conds.make_condition(function(line_to_cursor)
    line_to_cursor = snippet_utils.fix_line_to_cursor(line_to_cursor)
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

M.get_ts_node_not_in_condition = function(node_types)
  return ls_conds.make_condition(function(line_to_cursor)
    line_to_cursor = snippet_utils.fix_line_to_cursor(line_to_cursor)
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
