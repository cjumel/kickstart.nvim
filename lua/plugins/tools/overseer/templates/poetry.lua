local utils = require("utils")

local function poetry_is_setup()
  if vim.fn.filereadable("poetry.lock") == 1 then
    return true
  elseif vim.fn.filereadable("pyproject.toml") == 1 and utils.file.contain("pyproject.toml", "[tool.poetry]") then
    return true
  else
    return false
  end
end

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
      callback = function(_) return poetry_is_setup() end,
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
      callback = function(_) return poetry_is_setup() end,
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
      callback = function(_) return poetry_is_setup() end,
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
