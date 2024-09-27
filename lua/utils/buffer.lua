-- Utilities to interact with the current buffer.

local M = {}

--- Determine whether the current buffer is temporary, that is not tied to an actual file (e.g. created by a plugin).
---@return boolean
function M.is_temporary()
  local temporary_filetypes = vim.g.temporary_filetypes or {}
  return vim.tbl_contains(temporary_filetypes, vim.bo.filetype)
end

--- Determine whether buffer tooling, like auto-formatting or linting, is disabled on the current buffer.
---@return boolean|nil _ True or false if tooling is enabled or disabled, respectively, or nil if it is unknown.
function M.tooling_is_disabled()
  -- Default locations where tooling is disabled
  if vim.g.disable_tooling_callback then
    local file_path = vim.fn.expand("%:p:~") -- Relative to $HOME with "~/" prefix
    if vim.g.disable_tooling_callback(file_path) then
      return true
    end
  end

  -- Additional buffers where tooling is disabled, set by ftplugins
  local disable_tooling_by_bufnr = vim.g.disable_tooling_by_bufnr or {}
  return disable_tooling_by_bufnr[vim.fn.bufnr()] -- True, false or nil (unknown yet)
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
  if git_dir_path == "" then
    return nil
  end

  return vim.fn.fnamemodify(git_dir_path, ":h") -- Parent directory of ".git/"
end

return M
