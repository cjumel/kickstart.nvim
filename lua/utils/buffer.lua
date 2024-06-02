-- Utilities regarding the current buffer.

local M = {}

--- Determine whether the current buffer is in the current working directory or not.
---@return boolean
function M.is_in_cwd()
  local path = vim.fn.expand("%:p") -- Absolute path of current buffer
  local cwd = vim.fn.getcwd() -- Absolute path of cwd
  return path:sub(1, #cwd) == cwd
end

--- Determine whether the current buffer is in the current project or not. The current project contains the files in the
--- current working directory and its subdirectories, without the files explicitly excluded from the project.
---@return boolean
function M.is_in_project()
  if not M.is_in_cwd() then
    return false
  end

  local bufnr = vim.fn.bufnr()
  local exclusion_status_by_bufnr = vim.g.exclusion_status_by_bufnr or {} -- Mapping bufnr -> boolean|nil
  local exclusion_status = exclusion_status_by_bufnr[bufnr] -- True: excluded, False: not excluded, nil: unknown
  return not exclusion_status
end

return M
