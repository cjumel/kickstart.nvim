local utils = require("utils")

local tags = { "python", "pytest" }

return {
  {
    name = "Pytest file",
    params = {
      path = {
        type = "string",
        desc = "Path of the file (default to the currently opened one)",
        optional = true,
        order = 1,
      },
      args = {
        type = "string",
        desc = "The additional arguments to pass to the command",
        optional = true,
        order = 2,
      },
    },
    builder = function(params)
      if params.path == nil then
        params.path = utils.path.get_current_file_path()
      else
        params.path = utils.path.normalize(params.path)
      end

      if params.path == nil then
        print("No file provided or found")
        return {}
      elseif vim.fn.filereadable(params.path) ~= 1 then
        print("Not a readable file: " .. params.path)
        return {}
      elseif string.sub(params.path, -3) ~= ".py" then
        print("Not a Python file: " .. params.path)
        return {}
      end

      return {
        cmd = { "pytest", params.path, params.args },
      }
    end,
    tags = tags,
  },
  {
    name = "Pytest directory",
    params = {
      path = {
        type = "string",
        desc = "Path of the directory (default to the currently opened one if in Oil buffer or to the current working directory",
        optional = true,
        order = 1,
      },
      args = {
        type = "string",
        desc = "The additional arguments to pass to the command",
        optional = true,
        order = 2,
      },
    },
    builder = function(params)
      if params.path == nil then
        params.path = utils.path.get_current_oil_directory({ fallback = "cwd" })
      else
        params.path = utils.path.normalize(params.path)
      end

      if params.path == nil then
        print("No directory provided or found")
        return {}
      elseif vim.fn.isdirectory(params.path) ~= 1 then
        print("Not a directory: " .. params.path)
        return {}
      end

      return {
        cmd = { "pytest", params.path, params.args },
      }
    end,
    tags = tags,
  },
}
