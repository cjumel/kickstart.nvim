local M = {}

-- Output whether the given path is a directory or not.
--- @param path string The path to check.
M.is_directory = function(path)
  return vim.fn.isdirectory(path) == 1
end

-- Output whether the given path is a file or not.
--- @param path string The path to check.
M.is_file = function(path)
  if M.is_directory(path) then
    return false
  end

  local f = io.open(path, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

return M
