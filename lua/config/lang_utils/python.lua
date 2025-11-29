local M = {}

local project_markers = { "pyproject.toml", "setup.py", "requirements.txt" }

---@return boolean
function M.is_project()
  return not vim.tbl_isempty(vim.fs.find(project_markers, {
    path = vim.fn.getcwd(),
    upward = true,
    stop = vim.env.HOME,
  }))
end

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

---@return boolean
function M.is_test_file()
  if vim.bo.filetype ~= "python" then
    error("Not a Python file")
  end
  local file_name = vim.fn.expand("%:t") -- File base name and its extension
  return (file_name:match("^test_") and file_name:match("%.py$")) or file_name:match("_test%.py$")
end

---@return string|nil
function M.get_test_function_name()
  if not M.is_test_file() then
    error("Not a Python test file")
  end
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

return M
