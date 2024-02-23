local M = {}

-- Normalize an input path, that is make it relative to the working directory or $HOME if possible,
-- and standardize its format.
---@param path string The path to normalize.
---@param opts table? Options to customize the normalization.
local normalize = function(path, opts)
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

-- Output the normalized path of the current file, or nil if no file is opened.
M.get_current_file_path = function()
  local path = vim.fn.expand("%:p")
  if path == "" then -- No file is opened
    return nil
  end

  return normalize(path)
end

-- Output the normalized path of the current working directory when in Oil buffer, or a fallback
-- value if no Oil buffer is opened.
---@param opts table? Options to customize the output path.
M.get_current_oil_directory = function(opts)
  opts = opts or {}

  if vim.bo.filetype == "oil" then -- An Oil buffer is opened
    local oil = package.loaded.oil
    if oil ~= nil then -- Oil is loaded
      return normalize(oil.get_current_dir(), opts)
    end
  end

  local fallback = opts.fallback or nil
  if fallback == "cwd" then
    return normalize(vim.fn.getcwd(), opts)
  else
    return nil
  end
end

return M
