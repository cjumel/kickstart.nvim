-- Utilities to interact with paths.

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

return M
