local M = {}

--- Output the name of the Python module corresponding to the current file.
---@return string
function M.get_module()
  if vim.bo.filetype ~= "python" then
    error("Not a Python file")
  end
  local path = vim.fn.expand("%:.") -- File path relative to cwd
  -- Remove various prefixes and suffixes, and replace "/" by "."
  local module_ = path:gsub("^src/", ""):gsub("%.py$", ""):gsub("%.pyi$", ""):gsub(".__init__$", ""):gsub("/", ".")
  return module_
end

--- Check if the current file is a Python test file.
---@return boolean
function M.is_test_file()
  local file_name = vim.fn.expand("%:t") -- File base name and its extension
  if file_name:match("^test_") and file_name:match("%.py$") then
    return true
  end
  if file_name:match("_test%.py$") then
    return true
  end
  return false
end

--- Output the name of the current Python test function using Treesitter, or nil if none can be found.
---@return string|nil
function M.get_test_function_name()
  local node = vim.treesitter.get_node() -- Get the Treesitter node under the cursor
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

-- Check if the current directory is a Python test directory.
---@return boolean
function M.is_test_dir()
  if vim.bo.filetype ~= "oil" then
    return false
  end
  local path = vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":.")
  return path:match("^tests/")
end

return M
