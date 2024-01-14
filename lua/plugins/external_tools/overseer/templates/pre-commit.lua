local arguments = require("plugins.external_tools.overseer.arguments")

return {
  {
    name = "Pre-commit run",
    tags = { "pre-commit" },
    builder = function(params)
      local arguments_path = arguments.get_path(params)

      if vim.fn.filewritable(arguments_path) == 1 then
        return {
          cmd = { "pre-commit", "run", "--file", arguments_path },
        }
      elseif vim.fn.isdirectory(arguments_path) == 1 then
        local pattern = ""
        if string.sub(arguments_path, -1) ~= "/" then
          pattern = pattern .. "/"
        end
        pattern = pattern .. "**/*"
        return {
          -- vim.fn.expandcmd is taken from the "shell" builtin template; without it pre-commit
          -- skips all the files in the directory
          cmd = vim.fn.expandcmd("pre-commit run --files " .. arguments_path .. pattern),
        }
      else
        print("Not a writable file or a directory: " .. arguments_path)
        return {}
      end
    end,
    _user_command_nargs = "?",
  },
  {
    name = "Pre-commit run all",
    tags = { "pre-commit" },
    builder = function()
      return {
        cmd = { "pre-commit", "run", "--all-files" },
      }
    end,
  },
}
