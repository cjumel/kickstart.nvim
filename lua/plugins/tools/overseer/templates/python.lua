local utils = require("utils")

local tags = { "python" }

return {
  {
    name = "Python file",
    builder = function(params)
      local path = utils.path.get_current_file_path()

      if path == nil then
        print("No file is opened")
        return {}
      elseif vim.fn.filereadable(path) ~= 1 then
        print("Not a readable file: " .. path)
        return {}
      elseif string.sub(path, -3) ~= ".py" then
        print("Not a Python file: " .. path)
        return {}
      end

      return {
        cmd = { "python", path, params.args },
      }
    end,
    desc = "Run the Python file opened in the current buffer",
    tags = tags,
    _user_command_nargs = "?",
  },
}
