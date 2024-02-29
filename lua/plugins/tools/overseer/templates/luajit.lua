local utils = require("utils")

local tags = { "luajit" }

return {
  {
    name = "LuaJIT file",
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
      elseif string.sub(params.path, -4) ~= ".lua" then
        print("Not a Lua file: " .. params.path)
        return {}
      end

      return {
        cmd = { "luajit", params.path, params.args },
      }
    end,
    tags = tags,
  },
}
