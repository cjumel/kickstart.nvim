local utils = require("utils")

local tags = { "luajit" }

return {
  {
    name = "LuaJIT file",
    builder = function(params)
      local path = utils.path.get_current_file_path()

      if path == nil then
        print("No file is opened")
        return {}
      elseif vim.fn.filereadable(path) ~= 1 then
        print("Not a readable file: " .. path)
        return {}
      elseif string.sub(path, -4) ~= ".lua" then
        print("Not a Lua file: " .. path)
        return {}
      end

      return {
        cmd = { "luajit", path, params.args },
      }
    end,
    desc = "Run the Lua file opened in the current buffer",
    tags = tags,
  },
}
