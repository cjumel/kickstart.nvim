local M = {}

-- Normalize an input path, that is make it relative to the working directory or $HOME if possible,
-- and standardize its format.
---@param path string The path to normalize.
local normalize = function(path)
  -- If the path is in the working directory, return a path relative to it without prefix
  -- Otherwise, if a path is in $HOME, return a path relative to it starting prefixed by "~/"
  -- Otherwise, return an absolute path
  path = vim.fn.fnamemodify(path, ":p:~:.")

  -- path can be "" (corresponds to working directory), but it is not recognized by
  -- vim.fn.isdirectory so let's change it to "."
  if path == "" then
    path = "."
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

-- Output the normalized path of the current working directory when in Oil buffer, or nil if no
-- Oil buffer is opened.
M.get_current_oil_directory = function()
  if vim.bo.filetype ~= "oil" then -- No Oil buffer is opened
    return nil
  end

  local oil = package.loaded.oil
  if oil == nil then -- Oil is not loaded
    return nil
  end

  return normalize(oil.get_current_dir())
end

return M
