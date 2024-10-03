-- Utilities to interact with the current buffer.

local filetypes = require("filetypes")

local M = {}

--- Determine whether the current buffer is temporary, that is not tied to an actual file (e.g. created by a plugin).
---@return boolean
function M.is_temporary() return vim.tbl_contains(filetypes.temporary_filetypes, vim.bo.filetype) end

--- Determine whether buffer tooling, like auto-formatting or linting, should be disabled on the current buffer or not.
---@return boolean
function M.tooling_is_disabled()
  local file_path = vim.fn.expand("%:p:~") -- Relative to $HOME with "~/" prefix
  return (
    file_path:match("/.venv/") -- Virtual environments
    or (file_path:match("^~/%..*/") and not file_path:match("^~/%.config/")) -- Hidden $HOME sub-directories
    or file_path:match("^~/Library/Caches/") -- Dependencies installed by package managers like `pip` or `poetry` then
  )
end

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

return M
