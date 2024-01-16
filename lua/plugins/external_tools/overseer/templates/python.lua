local arguments = require("plugins.external_tools.overseer.arguments")

local tags = { "python" }

return {
  {
    name = "Python run file",
    builder = function(params)
      local arguments_path = arguments.get_path(params, { mode = "file" })

      if vim.fn.filereadable(arguments_path) == 1 and vim.bo.filetype == "python" then
        return {
          cmd = { "python", arguments_path },
        }
      elseif arguments_path == nil then
        print("No path was provided")
        return {}
      else
        print("Not a readable Python file: " .. arguments_path)
        return {}
      end
    end,
    desc = "Run a Python file passed as argument or the current buffer",
    tags = tags,
    _user_command_nargs = "?",
  },
}
