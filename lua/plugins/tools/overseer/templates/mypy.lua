local utils = require("utils")

local tags = { "python", "mypy" }

local mypy_params = {
  args = {
    type = "string",
    desc = "Additional arguments",
    optional = true,
    default = "--strict",
  },
}

return {
  {
    name = "Mypy file",
    condition = {
      callback = function(_) return vim.bo.filetype == "python" and utils.project.is_python() end,
    },
    params = mypy_params,
    builder = function(params)
      local path = utils.path.get_current_file_path()
      if path == nil then
        vim.notify("No file found")
        return {}
      end

      return {
        cmd = { "mypy", params.args, path },
      }
    end,
    tags = tags,
  },
  {
    name = "Mypy directory",
    condition = {
      callback = function(_) return vim.bo.filetype == "oil" and utils.project.is_python() end,
    },
    params = mypy_params,
    builder = function(params)
      local path = utils.path.get_current_oil_directory({ fallback = "cwd" })
      if path == nil then
        vim.notify("No directory provided or found")
        return {}
      end

      return {
        cmd = { "mypy", params.args, path },
      }
    end,
    tags = tags,
  },
  {
    name = "Mypy cwd",
    condition = {
      callback = function(_) return utils.project.is_python() end,
    },
    params = mypy_params,
    builder = function(params)
      local path = utils.path.normalize(vim.fn.getcwd())
      if path == nil then
        vim.notify("No directory found")
        return {}
      end

      return {
        cmd = { "mypy", params.args, path },
      }
    end,
    tags = tags,
  },
}
