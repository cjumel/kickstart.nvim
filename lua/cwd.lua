-- Utilities to interact with the current working directory.

local M = {}

--- Output the path of the root of the Git repository containing the current working directory, if it exists, or nil.
---@return string|nil
function M.get_git_root()
  -- Find the path of a ".git" directory in the cwd or any of its parent
  local git_dir_path = vim.fn.finddir(".git", vim.fn.getcwd() .. ";")
  if git_dir_path == "" then -- ".git" directory not found
    return nil
  end

  return vim.fn.fnamemodify(git_dir_path, ":h") -- Parent directory of ".git/"
end

return M
