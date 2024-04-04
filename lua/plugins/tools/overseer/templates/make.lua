local utils = require("utils")

local tags = { "make" }

return {
  {
    name = "Make",
    condition = {
      callback = function(_) return utils.dir.contain_files({ "Makefile" }) end,
    },
    params = {
      args = {
        type = "string",
        desc = "Arguments",
        optional = false,
      },
    },
    builder = function(params)
      return {
        cmd = { "make", params.args },
      }
    end,
    tags = tags,
  },
}
