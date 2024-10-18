-- Utilities to interact with the current buffer.

local M = {}

--- Output the path of the parent directory of the current buffer file, if it exists, or nil.
---@return string|nil
function M.get_parent_dir()
  local file_path = vim.fn.expand("%:p") -- Absolute current file path
  if file_path == "" then -- Buffer is not an actual file
    return nil
  end
  return vim.fn.fnamemodify(file_path, ":h") -- Parent directory of the current buffer file
end

--- Output the path of the root of the Git repository containing the current buffer, if it exists, or nil.
---@return string|nil
function M.get_git_root()
  local parent_dir = M.get_parent_dir()
  if parent_dir == nil then
    return nil
  end

  -- Find the path of a ".git" directory in any parent directory of the current buffer
  local git_dir_path = vim.fn.finddir(".git", parent_dir .. ";")
  if git_dir_path == "" then -- ".git" directory not found
    return nil
  end

  return vim.fn.fnamemodify(git_dir_path, ":h") -- Parent directory of ".git/"
end

--- Determine whether the current buffer is in the current project or not. The current project is considered to be
--- any of the current working directory and the Git repository containing the current working directory, if any.
---@return boolean
function M.is_in_project()
  local file_path = vim.fn.expand("%:p") -- Absolute path of the current file

  if file_path:match("^" .. vim.fn.getcwd()) then
    return true
  end

  local git_root = require("cwd").get_git_root() -- Can be a relative path or nil (not found)
  if git_root ~= nil then
    git_root = vim.fn.fnamemodify(git_root, ":p") -- Make path absolute
    if file_path:match("^" .. git_root) then
      return true
    end
  end

  return false
end

--- Determine whether the current buffer is in an external dependency. External dependencies are projects installed by
--- third parties, like package managers, and which are not supposed to be modified by hand.
---@return boolean
function M.is_external_dependency()
  local file_path = vim.fn.expand("%:p:~") -- Current file path relative to home directory with "~" prefix or absolute

  return (
    (
      file_path:match("^~/%..*/") -- In a hidden directory of the home directory
      and not file_path:match("^~/%.config/") -- Except for the configuration directory
    )
    or file_path:match("^~/Library/Caches/") -- Dependencies installed by package managers like Pip or Poetry
    or file_path:match("/.venv/") -- In a virtual environment (typically in Python)
  )
end

return M
