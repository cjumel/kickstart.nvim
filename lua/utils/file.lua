local M = {}

--- Check if a file contains a target string.
---@param path string The path to the file.
---@param target string The target string to search for.
---@return boolean
function M.contain(path, target)
  local file = io.open(path, "r")
  if not file then -- Unable to open file
    return false
  end

  for line in file:lines() do
    if string.find(line, target, 1, true) then
      file:close()
      return true
    end
  end

  file:close()
  return false
end

return M
