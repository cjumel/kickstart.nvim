local M = {}

local clean_args = function(args)
  -- args is a string, optionally with white spaces; it cannot have leading white spaces, but it
  -- can have trailing ones, so let's remove them.
  while string.sub(args, -1) == " " do
    args = string.sub(args, 1, -2)
  end

  return args
end

local clean_path = function(raw_path)
  if raw_path == nil then
    return nil
  end

  -- If the path is in the current directory, return a path relative to it
  -- Otherwise, if a path is in $HOME, return a path relative to it starting with "~/"
  -- Otherwise, return an absolute path
  local path = vim.fn.fnamemodify(raw_path, ":p:~:.")

  if path == "" then -- Correspond to current directory but not recognized by vim.fn.isdirectory
    return "."
  else
    return path
  end
end

local get_raw_path = function(params, opts)
  opts = opts or {}
  local mode = opts.mode or "all" -- "all", "file" or "dir"

  if params.args ~= "" then -- An argument was passed
    return clean_args(params.args)
  end

  if vim.bo.filetype == "oil" then -- An Oil buffer is opened
    if mode == "all" or mode == "dir" then
      local ok, oil = pcall(require, "oil")
      if ok then
        return oil.get_current_dir()
      end
    end
  end

  local file_path = vim.fn.expand("%:p")

  if file_path ~= "" then -- A file is opened
    if mode == "all" or mode == "file" then
      return file_path
    end
  end

  return nil
end

M.get_path = function(params, opts)
  local raw_path = get_raw_path(params, opts)
  return clean_path(raw_path)
end

return M
