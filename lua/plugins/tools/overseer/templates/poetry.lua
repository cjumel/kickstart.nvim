local utils = require("utils")

local tags = { "python", "poetry" }

return {
  {
    name = "Poetry install",
    condition = {
      callback = function(_)
        return utils.dir.contain_files({ "pyproject.toml", "poetry.lock" })
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
        cmd = { "poetry", "install", params.args },
      }
    end,
    tags = tags,
  },
  {
    name = "Poetry update",
    condition = {
      callback = function(_)
        return utils.dir.contain_files({ "pyproject.toml", "poetry.lock" })
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
        cmd = { "poetry", "update", params.args },
      }
    end,
    tags = tags,
  },
  {
    name = "Poetry add",
    condition = {
      callback = function(_)
        return utils.dir.contain_files({ "pyproject.toml", "poetry.lock" })
      end,
    },
    params = {
      package = {
        type = "string",
        desc = "Name of the package to add",
        optional = false,
        order = 1,
      },
      args = {
        type = "string",
        desc = "Additional arguments",
        optional = true,
        order = 2,
      },
    },
    builder = function(params)
      return {
        cmd = { "poetry", "add", params.package, params.args },
      }
    end,
    tags = tags,
  },
}
