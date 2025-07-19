local M = {}

--- Output the name of the Lua module corresponding to the current file.
---@return string
function M.get_module()
  if vim.bo.filetype ~= "lua" then
    error("Not a Lua file")
  end
  local path = vim.fn.expand("%:.") -- File path relative to cwd
  -- Only keep the path part after "lua/" (useful for modules not in the cwd)
  local path_split = vim.fn.split(path, "lua/")
  if #path_split >= 2 then
    path = path_split[#path_split]
  elseif path:sub(1, 4) ~= "lua/" then -- File is not inside a "lua/" directory
    error("File is not a module")
  end
  -- Remove various prefixes and suffixes, and replace "/" by "."
  local module_ = path:gsub("^lua/", ""):gsub("%.lua$", ""):gsub(".init$", ""):gsub("/", ".")
  return module_
end

return M
