local arguments = require("plugins.tools.overseer.arguments")

local tags = { "luajit" }

return {
  {
    name = "LuaJIT file",
    builder = function(params)
      local arguments_path = arguments.get_path(params, { mode = "file" })

      if arguments_path == nil then
        print("No path was provided")
        return {}
      elseif vim.fn.filereadable(arguments_path) ~= 1 then
        print("Not a readable file: " .. arguments_path)
        return {}
      elseif string.sub(arguments_path, -4) ~= ".lua" then
        print("Not a Lua file: " .. arguments_path)
        return {}
      end

      return {
        cmd = { "luajit", arguments_path },
      }
    end,
    desc = "Run a Lua file passed as argument or the current buffer",
    tags = tags,
    _user_command_nargs = "?",
  },
}
