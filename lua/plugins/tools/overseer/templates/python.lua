local utils = require("utils")

local tags = { "python" }

return {
  {
    name = "Python file",
    condition = {
      filetype = "python",
    },
    params = {
      args = {
        type = "string",
        desc = "Additional arguments",
        optional = true,
      },
    },
    builder = function(params)
      local path = utils.path.get_current_file_path()
      if path == nil then
        vim.notify("No file found")
        return {}
      end

      return {
        cmd = { "python", path, params.args },
      }
    end,
    tags = tags,
  },
}
