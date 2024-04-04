local utils = require("utils")

local function pytest_has_config()
  return utils.dir.contain_files({ "pytest.ini", "pyproject.toml", "tox.ini", "setup.cfg" })
end
local args = {
  type = "string",
  desc = "Additional arguments",
  optional = true,
  default = [[-m "not slow"]],
}
local tags = { "python", "pytest" }

return {
  {
    name = "Pytest file",
    condition = {
      callback = function(_) return pytest_has_config() and vim.bo.filetype == "python" end,
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
        cmd = { "pytest", path, params.args },
      }
    end,
    tags = tags,
  },
  {
    name = "Pytest directory",
    condition = {
      callback = function(_) return pytest_has_config() and vim.bo.filetype == "oil" end,
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
        cmd = { "pytest", path, params.args },
      }
    end,
    tags = tags,
  },
  {
    name = "Pytest",
    condition = {
      callback = function(_) return pytest_has_config() end,
    },
    params = {
      args = args,
    },
    builder = function(params)
      return {
        cmd = { "pytest", params.args },
      }
    end,
    tags = tags,
  },
}
