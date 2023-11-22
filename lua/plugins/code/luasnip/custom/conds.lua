local M = {}

-- Condition determining wether a snippet is in actual code or not, using treesitter.
function M.is_in_code(line_to_cursor, matched_trigger, captures)
  local _, row, col, _, _ = unpack(vim.fn.getcurpos())
  local node = vim.treesitter.get_node({
    pos = { row - 1, col - #matched_trigger - 1 },
  })
  return node
    and not (
      node:type() == "comment"
      or node:type() == "comment_content"
      or node:type() == "string"
      or node:type() == "string_content"
    )
end

-- Condition determining wether a snippet is in a comment or not, using treesitter.
function M.is_in_comment(line_to_cursor, matched_trigger, captures)
  local _, row, col, _, _ = unpack(vim.fn.getcurpos())
  local node = vim.treesitter.get_node({
    pos = { row - 1, col - #matched_trigger - 1 },
  })
  return node and (node:type() == "comment" or node:type() == "comment_content")
end

return M
