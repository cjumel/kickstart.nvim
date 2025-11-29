local M = {}

local project_markers = { "init.lua" }

---@return boolean
function M.is_project()
  return not vim.tbl_isempty(vim.fs.find(project_markers, {
    path = vim.fn.getcwd(),
    upward = true,
    stop = vim.env.HOME,
  }))
end

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
