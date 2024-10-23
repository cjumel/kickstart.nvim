-- Utilities to interact with the current buffer.

local cwd = require("cwd")

local M = {}

--- Output the path corresponding to the file or directory linked to the current regular or Oil buffer, or nil.
---@param mods string|nil the file path modifiers to apply to the output.
---@return string|nil
function M.get_path(mods)
  local path
  if vim.bo.buftype == "" then
    path = vim.fn.expand("%")
  elseif vim.bo.filetype == "oil" then
    local oil = require("oil")
    path = oil.get_current_dir()
    if path == nil then
      return nil
    end
  else
    return nil
  end

  if mods then
    path = vim.fn.fnamemodify(path, mods)
  end
  return path
end

--- Output the root path of the Git repository containing the file or directory linked to the current regular or Oil
--- buffer, or nil.
---@param mods string|nil the file path modifiers to apply to the output.
---@return string|nil
function M.get_git_root(mods)
  local parent_dir_path = M.get_path(":h") -- Parent directory of buffer if a file, or the directory itself
  if parent_dir_path == nil then -- Current buffer is not a regular buffer or an Oil buffer
    return nil
  end

  -- Find the path of a ".git" directory in any parent directory of the current buffer
  local git_dir_path = vim.fn.finddir(".git", parent_dir_path .. ";")
  if git_dir_path == "" then -- ".git" directory not found
    return nil
  end

  local dir_path = vim.fn.fnamemodify(git_dir_path, ":h") -- Parent directory of ".git/"
  if mods then
    dir_path = vim.fn.fnamemodify(dir_path, mods)
  end
  return dir_path
end

--- Determine whether the file or directory linked to the current regular or Oil buffer is in the current project or
--- not. The current project is considered to be any of the current working directory and the Git repository containing
--- the current working directory, if any.
---@return boolean
function M.is_in_current_project()
  local path = M.get_path(":p") -- Absolute path of the current file or directory
  if path == nil then -- Current buffer is not a regular buffer or an Oil buffer
    return false
  end

  if path:match("^" .. vim.fn.getcwd()) then -- File or directory is in the cwd
    return true
  end

  local git_root = cwd.get_git_root(":p") -- Absolute path of the Git repository root, or nil
  if git_root ~= nil and path:match("^" .. git_root) then -- File or directory is in the Git repository root
    return true
  end

  return false
end

--- Determine whether the file or directory linked to the current regular or Oil buffer is in an external dependency or
--- not. External dependencies are considered to be projects installed by third parties, like package managers, and
--- which are not supposed to be modified by hand.
---@return boolean
function M.is_external_dependency()
  local path = M.get_path(":p:~") -- Relative to home directory with "~" prefix or absolute
  if path == nil then -- Current buffer is not a regular buffer or an Oil buffer
    return false
  end

  return (
    (
      path:match("^~/%..*/") -- In a hidden directory of the home directory
      and not path:match("^~/%.config/") -- Except for the configuration directory
    )
    or path:match("^~/Library/Caches/") -- Dependencies installed by package managers like Pip or Poetry
    or path:match("/.venv/") -- In a virtual environment (typically in Python)
  )
end

--- Determine whether the file or directory linked to the current regular or Oil buffer is in a Lua project or not. Lua
--- projects are considered to be any directory which contains a Lua file or a Lua configuration file, or which has
--- an ancestor which does. This does not take into account symbolic links.
---@return boolean
function M.is_in_lua_project()
  local path = M.get_path()
  if path == nil then -- Current buffer is not a regular buffer or an Oil buffer
    return false
  end

  return not vim.tbl_isempty(
    vim.fs.find(
      function(name, _) return name:match(".*%.lua$") or vim.tbl_contains({ ".stylua.toml", "stylua.toml" }, name) end,
      {
        type = "file",
        path = path,
        upward = true, -- Search in the current directory and its parents
        stop = M.get_git_root() or vim.env.HOME, -- Stop searching at the Git root or the HOME directory
      }
    )
  )
end

--- Determine whether the file or directory linked to the current regular or Oil buffer is in a Python project or not.
--- Python projects are considered to be any directory which contains a Python file or a Python configuration file, or
--- which has an ancestor which does. This does not take into account symbolic links.
---@return boolean
function M.is_in_python_project()
  local path = M.get_path()
  if path == nil then -- Current buffer is not a regular buffer or an Oil buffer
    return false
  end

  return not vim.tbl_isempty(
    vim.fs.find(
      function(name, _)
        return name:match(".*%.py$") or vim.tbl_contains({ "pyproject.toml", "poetry.lock", ".ruff.toml" }, name)
      end,
      {
        type = "file",
        path = path,
        upward = true, -- Search in the current directory and its parents
        stop = M.get_git_root() or vim.env.HOME, -- Stop searching at the Git root or the HOME directory
      }
    )
  )
end

--- Output the kind of project (filetype or file extension related to the main project language) associated with the
--- file or directory linked to the current regular or Oil buffer.
---@param opts table|nil The options of the function:
---   - output_extension bool If True, output a file extension instead of a filetype.
---@return string|nil
function M.get_project_filetype(opts)
  opts = opts or {}
  local output_extension = opts.output_extension or false

  if M.is_in_lua_project() then
    return "lua"
  elseif M.is_in_python_project() then
    if not output_extension then
      return "python"
    else
      return "py"
    end
  end
end

return M
