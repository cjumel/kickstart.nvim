local utils = require("utils")

local function poetry_has_lock_file() return utils.dir.contain_files({ "poetry.lock" }) end
local package = {
  type = "string",
  desc = "Name of the package to add",
  optional = false,
  order = 1,
}
local args = {
  type = "string",
  desc = "Additional arguments",
  optional = true,
}
local tags = { "python", "poetry" }

return {
  {
    name = "Poetry install",
    condition = {
      callback = function(_) return poetry_has_lock_file() end,
    },
    params = {
      args = args,
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
      callback = function(_) return poetry_has_lock_file() end,
    },
    params = {
      args = args,
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
      callback = function(_) return poetry_has_lock_file() end,
    },
    params = {
      package = package,
      args = args,
    },
    builder = function(params)
      return {
        cmd = { "poetry", "add", params.package, params.args },
      }
    end,
    tags = tags,
  },
}
