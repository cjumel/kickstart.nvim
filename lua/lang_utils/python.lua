local M = {}

--- Check if the current file is a Python test file.
---@return boolean
function M.is_test_file()
  local file_name = vim.fn.expand("%:t") -- File base name and its extension
  local file_starts_with_test = file_name:match("^test_") and file_name:match("%.py$")
  if file_starts_with_test then
    return true
  end
  local file_ends_with_test = file_name:match("_test%.py$")
  if file_ends_with_test then
    return true
  end
  return false
end

--- Output the name of the current Python test function using Treesitter, or nil if none can be found.
---@return string|nil
function M.get_test_function_name()
  local node = vim.treesitter.get_node() -- Get the Teesitter node under the cursor
  while node ~= nil do
    if node:type() == "function_definition" then
      local name_nodes = node:field("name")
      assert(#name_nodes == 1, "Expected exactly one name node")
      local name_node = name_nodes[1]

      local function_name = vim.treesitter.get_node_text(name_node, vim.api.nvim_get_current_buf())
      if function_name:match("^test_") then -- This is a test function
        return function_name
      end
    end
    node = node:parent()
  end

  return nil
end

return M
