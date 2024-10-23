-- Utilities to interact with the current working directory.

local M = {}

--- Output the root path of the Git repository containing the current working directory, or nil.
---@param mods string|nil The file path modifiers to apply to the output.
---@return string|nil
function M.get_git_root(mods)
  -- Find the path of a ".git" directory in the cwd or any of its parent
  local git_dir_path = vim.fn.finddir(".git", vim.fn.getcwd() .. ";")
  if git_dir_path == "" then -- ".git" directory not found
    return nil
  end

  local dir_path = vim.fn.fnamemodify(git_dir_path, ":h") -- Parent directory of ".git/"
  if mods then
    dir_path = vim.fn.fnamemodify(dir_path, mods)
  end
  return dir_path
end

return M
