local arguments = require("plugins.external_tools.overseer.arguments")

local tags = { "pre-commit" }

return {
  {
    name = "Pre-commit run",
    builder = function(params)
      return {
        cmd = vim.fn.expandcmd("pre-commit run " .. params.args),
      }
    end,
    desc = "Run pre-commit with arbitrary arguments",
    tags = tags,
    _user_command_nargs = "*",
  },
  {
    name = "Pre-commit run file",
    builder = function(params)
      local arguments_path = arguments.get_path(params, { mode = "file" })

      if vim.fn.filewritable(arguments_path) == 1 then
        return {
          cmd = { "pre-commit", "run", "--file", arguments_path },
        }
      elseif arguments_path == nil then
        print("No path was provided")
        return {}
      else
        print("Not a writable file: " .. arguments_path)
        return {}
      end
    end,
    desc = "Run pre-commit on a file passed as argument or on the current buffer",
    tags = tags,
    _user_command_nargs = "?",
  },
  {
    name = "Pre-commit run directory",
    builder = function(params)
      local arguments_path = arguments.get_path(params, { mode = "dir" })
      if arguments_path == nil then -- No path was provided
        arguments_path = "."
      end

      if vim.fn.isdirectory(arguments_path) == 1 then
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
        print("Not a directory: " .. arguments_path)
        return {}
      end
    end,
    desc = "Run pre-commit on a directory passed as argument, or on the current directory if in an Oil buffer, or on the current working directory",
    tags = tags,
    _user_command_nargs = "?",
  },
  {
    name = "Pre-commit run all files",
    builder = function()
      return {
        cmd = { "pre-commit", "run", "--all-files" },
      }
    end,
    desc = "Run pre-commit on all repository files",
    tags = tags,
  },
}
