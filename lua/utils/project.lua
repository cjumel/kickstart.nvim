local dir_utils = require("utils.dir")

local M = {}

local python_project_files = {
  ".ruff.toml",
  "__init__.py",
  "conftest.py",
  "pyproject.toml",
  "setup.py",
}

M.is_python = function() return dir_utils.contain_files(python_project_files) end

local lua_project_files = {
  ".stylua.toml",
  "init.lua",
}
local lua_project_dirs = {
  "lua",
}

M.is_lua = function()
  return dir_utils.contain_files(lua_project_files) or dir_utils.contain_dirs(lua_project_dirs)
end

--- Output the path of the Git repository root containing the current project, if any.
---@return string|nil
function M.get_repository_root_path()
  local dot_git_dir_path = vim.fn.finddir(".git", vim.fn.getcwd() .. ";")
  if dot_git_dir_path == "" then -- ".git" directory not found
    return nil
  end

  return vim.fn.fnamemodify(dot_git_dir_path, ":h") -- Parent directory of .git/
end

return M
