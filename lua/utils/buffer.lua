-- Utilities to interact with the current buffer.

local M = {}

--- Determine whether buffer tooling, like auto-formatting or linting, is disabled on the current buffer.
---@return boolean|nil _ True or false if tooling is enabled or disabled, respectively, or nil if it is unknown.
function M.tooling_is_disabled()
  -- Default locations where tooling is disabled
  local file_path = vim.fn.expand("%:p:~") -- Relative to $HOME with "~/" prefix
  if
    file_path:match("/.venv/") -- Virtual environments
    or (file_path:match("^~/%..*/") and not file_path:match("^~/%.config/")) -- Hidden $HOME sub-directories
    or file_path:match("^~/Library/Caches/") -- Cache of package managers tools like `pip` or `poetry`
  then
    return true
  end

  -- Additional buffers where tooling is disabled, set by ftplugins
  local disable_tooling_by_bufnr = vim.g.disable_tooling_by_bufnr or {}
  return disable_tooling_by_bufnr[vim.fn.bufnr()] -- True, false or nil (unknown yet)
end

--- Determine whether buffer tooling, like auto-formatting or linting, should be disabled on the current buffer, in
--- case it hasn't been checked yet and the provided callback function is evaluated to `true`.
---@param callback function(): boolean The callback to evaluate.
---@return nil
function M.should_disable_tooling(callback)
  if M.tooling_is_disabled() ~= nil then -- Whether tooling should be disabled has already been computed
    return false
  end

  return callback()
end

--- Disable buffer tooling, like auto-formatting or linting, on the current buffer.
---@return nil
function M.disable_tooling()
  local disable_tooling_by_bufnr = vim.g.disable_tooling_by_bufnr or {}
  disable_tooling_by_bufnr[vim.fn.bufnr()] = true
  vim.g.disable_tooling_by_bufnr = disable_tooling_by_bufnr
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
