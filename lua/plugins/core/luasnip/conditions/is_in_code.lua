local ls_conditions = require("luasnip.extras.conditions")

local get_treesitter_node = require("plugins.core.luasnip.conditions.utils").get_treesitter_node

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

return is_in_code_condition
