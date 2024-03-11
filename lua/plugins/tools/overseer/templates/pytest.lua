local utils = require("utils")

local tags = { "python", "pytest" }

return {
  {
    name = "Pytest file",
    condition = {
      callback = function(_)
        return vim.bo.filetype == "python"
          and utils.project.is_python()
          and utils.dir.contain_dirs({ "tests" })
      end,
    },
    params = {
      args = {
        type = "string",
        desc = "Additional arguments",
        optional = true,
      },
    },
    builder = function(params)
      local path = utils.path.get_current_file_path()
      if path == nil then
        vim.notify("No file found")
        return {}
      end

      return {
        cmd = { "pytest", path, params.args },
      }
    end,
    tags = tags,
  },
  {
    name = "Pytest directory",
    condition = {
      callback = function(_)
        return vim.bo.filetype == "oil"
          and utils.project.is_python()
          and utils.dir.contain_dirs({ "tests" })
      end,
    },
    params = {
      args = {
        type = "string",
        desc = "Additional arguments",
        optional = true,
      },
    },
    builder = function(params)
      local path = utils.path.get_current_oil_directory({ fallback = "cwd" })
      if path == nil then
        vim.notify("No directory provided or found")
        return {}
      end

      return {
        cmd = { "pytest", path, params.args },
      }
    end,
    tags = tags,
  },
  {
    name = "Pytest",
    condition = {
      callback = function(_)
        return utils.project.is_python() and utils.dir.contain_dirs({ "tests" })
      end,
    },
    params = {
      args = {
        type = "string",
        desc = "Additional arguments",
        optional = true,
      },
    },
    builder = function(params)
      return {
        cmd = { "pytest", params.args },
      }
    end,
    tags = tags,
  },
}
