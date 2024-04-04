local utils = require("utils")

local function make_has_file() return utils.dir.contain_files({ "Makefile" }) end
local args = {
  type = "string",
  desc = "Additional arguments",
  optional = true,
}
local tags = { "make" }

return {
  {
    name = "Make",
    condition = {
      callback = function(_) make_has_file() end,
    },
    params = {
      args = args,
    },
    builder = function(params)
      return {
        cmd = { "make", params.args },
      }
    end,
    tags = tags,
  },
}
