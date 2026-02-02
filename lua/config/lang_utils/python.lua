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

return M
