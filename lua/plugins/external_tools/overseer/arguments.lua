local M = {}

local get_raw_path = function(params)
  if params.args ~= "" then -- An argument was passed
    local args = params.args

    -- args can be a string with white spaces if nargs = "?". In that case, it cannot have leading
    -- white spaces, but it can have trailing white spaces, so let's remove them.
    while string.sub(args, -1) == " " do
      args = string.sub(args, 1, -2)
    end

    return args
  end

  if vim.bo.filetype == "oil" then -- In an Oil buffer
    local ok, oil = pcall(require, "oil")
    if ok then
      return oil.get_current_dir()
    end
  end

  -- Regular file open or no file open
  return vim.fn.expand("%:p")
end

M.get_path = function(params)
  local raw_path = get_raw_path(params)

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

return M
