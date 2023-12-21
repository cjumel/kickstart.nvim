-- These functions must be used with the `condition` option in snippets, they are not suited to
-- the `show_condition` as they don't support the right parameters for it.

local cond_obj = require("luasnip.extras.conditions")

local M = {}

local function get_treesitter_node(matched_trigger)
  local _, row, col, _, _ = unpack(vim.fn.getcurpos())
  return vim.treesitter.get_node({
    pos = { row - 1, col - #matched_trigger - 1 },
  })
end

-- Condition determining wether a snippet is in actual code or not, using treesitter.
local function is_in_code(_, matched_trigger, _)
  local is_treesitter_parsable, node = pcall(get_treesitter_node, matched_trigger)
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
local function is_in_comment(_, matched_trigger, _)
  local is_treesitter_parsable, node = pcall(get_treesitter_node, matched_trigger)
  if is_treesitter_parsable then
    return node and (node:type() == "comment" or node:type() == "comment_content")
  else
    return false
  end
end
M.is_in_comment = cond_obj.make_condition(is_in_comment)

return M
