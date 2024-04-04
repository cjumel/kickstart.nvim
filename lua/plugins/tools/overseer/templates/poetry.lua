local utils = require("utils")

local tags = { "python", "poetry" }

local condition = {
  callback = function(_)
    return utils.dir.contain_files({
      "pyproject.toml",
      "poetry.lock",
    })
  end,
}

local args_param = {
  type = "string",
  desc = "Additional arguments",
  optional = true,
}

return {
  {
    name = "Poetry install",
    condition = condition,
    params = { args = args_param },
    builder = function(params)
      return {
        cmd = { "poetry", "install", params.args },
      }
    end,
    tags = tags,
  },
  {
    name = "Poetry update",
    condition = condition,
    params = { args = args_param },
    builder = function(params)
      return {
        cmd = { "poetry", "update", params.args },
      }
    end,
    tags = tags,
  },
  {
    name = "Poetry add",
    condition = condition,
    params = {
      package = {
        type = "string",
        desc = "Name of the package to add",
        optional = false,
        order = 1,
      },
      args = args_param,
    },
    builder = function(params)
      return {
        cmd = { "poetry", "add", params.package, params.args },
      }
    end,
    tags = tags,
  },
}
