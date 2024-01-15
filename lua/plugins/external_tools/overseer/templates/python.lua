local arguments = require("plugins.external_tools.overseer.arguments")

return {
  {
    name = "Python run file",
    tags = { "python" },
    builder = function(params)
      local arguments_path = arguments.get_path(params)

      local is_readable_file = vim.fn.filereadable(arguments_path) == 1
      local is_python_file = string.sub(arguments_path, -3) == ".py"
      if is_readable_file and is_python_file then
        return {
          cmd = { "python", arguments_path },
        }
      else
        print("Not a readable Python file: " .. arguments_path)
        return {}
      end
    end,
    _user_command_nargs = "?",
  },
}
