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

return M
