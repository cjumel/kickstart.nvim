local utils = require("utils")

local function mypy_is_setup()
  if vim.fn.filereadable("mypy.ini") == 1 then
    return true
  elseif vim.fn.filereadable(".mypy.ini") == 1 then
    return true
  elseif
    vim.fn.filereadable("pyproject.toml") == 1 and utils.file.contain("pyproject.toml", "mypy =")
  then
    return true
  else
    return false
  end
end
local args = {
  type = "string",
  desc = "Additional arguments",
  optional = true,
  default = "--strict",
}
local tags = { "python", "mypy" }

return {
  {
    name = "Mypy file",
    condition = {
      callback = function(_) return mypy_is_setup() and vim.bo.filetype == "python" end,
    },
    params = {
      args = args,
    },
    builder = function(params)
      local path = utils.path.get_current_file_path()
      if path == nil then
        vim.notify("No file found")
        return {}
      end

      return {
        cmd = { "mypy", path, params.args },
      }
    end,
    tags = tags,
  },
  {
    name = "Mypy directory",
    condition = {
      callback = function(_) return mypy_is_setup() and vim.bo.filetype == "oil" end,
    },
    params = {
      args = args,
    },
    builder = function(params)
      local path = utils.path.get_current_oil_directory({ fallback = "cwd" })
      if path == nil then
        vim.notify("No directory provided or found")
        return {}
      end

      return {
        cmd = { "mypy", path, params.args },
      }
    end,
    tags = tags,
  },
  {
    name = "Mypy cwd",
    condition = {
      callback = function(_) return mypy_is_setup() end,
    },
    params = {
      args = args,
    },
    builder = function(params)
      local path = utils.path.normalize(vim.fn.getcwd())
      if path == nil then
        vim.notify("No directory found")
        return {}
      end

      return {
        cmd = { "mypy", path, params.args },
      }
    end,
    tags = tags,
  },
}
