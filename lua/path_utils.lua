-- Utilities to interact with paths.

local nvim_config = require("nvim_config")

local M = {}

--- Output the root path of the Git repository containing the directory whose path is provided, or nil if there is none.
---@param dir_path string|nil The path of a directory (default to the cwd).
---@param mods string|nil The modifiers to apply to the output path.
---@return string|nil
function M.get_git_root(dir_path, mods)
  dir_path = dir_path or vim.fn.getcwd()

  -- Find the path of a ".git" directory in the target directory or any of its ancestors
  local dot_git_dir_path = vim.fn.finddir(".git", dir_path .. ";")
  if dot_git_dir_path == "" then -- ".git" directory not found
    return
  end

  local git_root_path = vim.fn.fnamemodify(dot_git_dir_path, ":h") -- Parent directory of ".git/"
  if mods then
    git_root_path = vim.fn.fnamemodify(git_root_path, mods)
  end
  return git_root_path
end

--- Output the root path of the current project. The current project is considered to be the Git repository containing
--- the cwd, if there is one, or the cwd itself.
---@param mods string|nil The modifiers to apply to the output path.
---@return string
function M.get_project_root(mods)
  local git_root_path = M.get_git_root(nil, mods)
  if git_root_path then
    return git_root_path
  end

  local cwd_path = vim.fn.getcwd()
  if mods then
    cwd_path = vim.fn.fnamemodify(cwd_path, mods)
  end
  return cwd_path
end

--- Output whether the file opened in the current buffer is in the current project or not.
---@return boolean
function M.file_is_in_project()
  local absolute_file_path = vim.fn.expand("%:p")
  local absolute_project_root_path = M.get_project_root(":p")
  if absolute_file_path:match("^" .. absolute_project_root_path) then
    return true
  end
  return false
end

--- Output whether the file opened in the current buffer matches one of the tooling blacklist path patterns.
---@return boolean
function M.file_matches_tooling_blacklist_patterns()
  if nvim_config.tooling_blacklist_path_patterns then
    local absolute_file_path = vim.fn.expand("%:p")
    for _, path_pattern in ipairs(nvim_config.tooling_blacklist_path_patterns) do
      if absolute_file_path:match(path_pattern) then
        return true
      end
    end
  end

  return false
end

return M
