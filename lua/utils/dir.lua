local M = {}

--- Get the path of the directory to check, depending on the options. If the input directory is
--- nil, use a fallback depending on `opts.fallback`, which could be `cwd` or `oil`.
---@param dir string|nil The path of the directory to check; if nil, use a fallback.
---@param opts table<string, any>|nil The options for the function.
---@return string|nil
local get_dir = function(dir, opts)
  if dir ~= nil then
    return dir
  end

  opts = opts or {}
  local fallback = opts.fallback or "cwd"
  if fallback == "cwd" then
    return vim.fn.getcwd()
  end

  if fallback == "oil" then
    local oil = package.loaded.oil
    if oil ~= nil then
      return oil.get_current_dir()
    end
  end
end

--- Check if the provided directory root contains any of the target files. If the input directory is
--- nil, use a fallback depending on `opts.fallback`, which could be `cwd` or `oil`.
---@param targets string[] The target file paths, relatively to the directory root.
---@param dir string|nil The path of the directory to check; if nil, use a fallback.
---@param opts table<string, any>|nil The options for the function.
---@return boolean
M.contain_files = function(targets, dir, opts)
  dir = get_dir(dir, opts)
  if dir == nil then
    return false
  end

  for _, target in ipairs(targets) do
    if vim.fn.filereadable(dir .. "/" .. target) == 1 then
      return true
    end
  end

  return false
end

--- Check if the provided directory root contains one of the target directories. If the input
--- directory is nil, use a fallback depending on `opts.fallback`, which could be `cwd` or `oil`.
---@param targets string[] The target directory paths, relatively to the directory root.
---@param dir string|nil The path of the directory to check; if nil, use a fallback.
---@param opts table<string, any>|nil The options for the function.
---@return boolean
M.contain_dirs = function(targets, dir, opts)
  dir = get_dir(dir, opts)
  if dir == nil then
    return false
  end

  for _, target in ipairs(targets) do
    if vim.fn.isdirectory(dir .. "/" .. target) == 1 then
      return true
    end
  end

  return false
end

return M
