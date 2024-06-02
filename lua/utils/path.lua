local M = {}

--- Normalize an input path, by making it relative to the working directory or $HOME when possible.
---@param path string The path to normalize.
---@param opts table<string, any>|nil Options to customize the normalization.
---@return string
M.normalize = function(path, opts)
  opts = opts or {}

  -- If the path is in the working directory, return a path relative to it without prefix
  -- Otherwise, if a path is in $HOME, return a path relative to it starting prefixed by "~/"
  -- Otherwise, return an absolute path
  path = vim.fn.fnamemodify(path, ":p:~:.")

  -- path can be "" (corresponds to working directory), but it is not recognized by
  -- vim.fn.isdirectory so let's change it
  if path == "" then
    local cwd_strategy = opts.cwd_strategy or "relative"
    if cwd_strategy == "absolute" then
      path = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:~")
    else
      path = "."
    end
  end

  return path
end

--- Output the normalized path of the current file, or nil if no file is opened.
---@param opts table<string, any>|nil Options to customize the output path.
---@return string|nil
M.get_current_file_path = function(opts)
  local path = vim.fn.expand("%:p")
  if path == "" then -- No file is opened
    return nil
  end

  return M.normalize(path, opts)
end

--- Output the normalized path of the current working directory when in Oil buffer, or a fallback
--- value if no Oil buffer is opened.
---@param opts table<string, any>|nil Options to customize the output path.
---@return string|nil
M.get_current_oil_directory = function(opts)
  opts = opts or {}

  if vim.bo.filetype == "oil" then -- An Oil buffer is opened
    local oil = package.loaded.oil
    if oil ~= nil then -- Oil is loaded
      return M.normalize(oil.get_current_dir(), opts)
    end
  end

  local fallback = opts.fallback or nil
  if fallback == "cwd" then
    return M.normalize(vim.fn.getcwd(), opts)
  else
    return nil
  end
end

--- Output the normalized path of the current buffer, or nil if no buffer is opened. Supported
--- buffer types are: Oil (output corresponding directory), and file.
---@param opts table<string, any>|nil Options to customize the output path.
---@return string|nil
M.get_current_buffer_path = function(opts)
  if vim.bo.filetype == "oil" then
    return M.get_current_oil_directory(opts)
  end

  return M.get_current_file_path(opts)
end

--- Output the path of the root of the Git repository containing the current working directory, if any.
---@return string|nil _ The relative or absolute path of the root of the Git repository, or nil if there is none.
function M.get_git_root()
  -- Find the path of a ".git" directory in the cwd or its parents
  local git_dir_path = vim.fn.finddir(".git", vim.fn.getcwd() .. ";")
  if git_dir_path == "" then -- ".git" directory not found
    return nil
  end
  return vim.fn.fnamemodify(git_dir_path, ":h") -- Parent directory of ".git/"
end

--- Output whether the current buffer is in the current working directory or not.
---@return boolean _ Whether the current buffer is in the current working directory or not.
function M.buffer_is_in_cwd()
  local path = vim.fn.expand("%:p") -- Absolute path of current buffer
  local cwd = vim.fn.getcwd() -- Absolute path of cwd
  return path:sub(1, #cwd) == cwd
end

return M
