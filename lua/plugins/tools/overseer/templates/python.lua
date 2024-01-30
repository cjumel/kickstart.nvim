local arguments = require("plugins.tools.overseer.arguments")

local tags = { "python" }

return {
  {
    name = "Python file",
    builder = function(params)
      local arguments_path = arguments.get_path(params, { mode = "file" })

      if arguments_path == nil then
        print("No path was provided")
        return {}
      elseif vim.fn.filereadable(arguments_path) ~= 1 then
        print("Not a readable file: " .. arguments_path)
        return {}
      elseif string.sub(arguments_path, -3) ~= ".py" then
        print("Not a Python file: " .. arguments_path)
        return {}
      end

      return {
        cmd = { "python", arguments_path },
      }
    end,
    desc = "Run a Python file passed as argument or the current buffer",
    tags = tags,
    _user_command_nargs = "?",
  },
}
