local utils = require("utils")

local args = {
  type = "string",
  desc = "Additional arguments",
  optional = true,
}
local tags = { "luajit" }

return {
  {
    name = "LuaJIT file",
    condition = {
      filetype = "lua",
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
        cmd = { "luajit", path, params.args },
      }
    end,
    tags = tags,
  },
}
