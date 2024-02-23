local utils = require("utils")

local tags = { "pre-commit" }

return {
  {
    name = "Pre-commit run file",
    builder = function(params)
      local path = utils.path.get_current_file_path()

      if path == nil then
        print("No file is opened")
        return {}
      elseif vim.fn.filewritable(path) ~= 1 then
        print("Not a readable file: " .. path)
        return {}
      end

      return {
        cmd = { "pre-commit", "run", "--file", path, params.args },
      }
    end,
    desc = "Run pre-commit on the file opened in the current buffer",
    tags = tags,
    _user_command_nargs = "?",
  },
  {
    name = "Pre-commit run directory",
    builder = function(params)
      local path = utils.path.get_current_oil_directory()
      if path == nil then -- No path was provided
        path = "."
      end

      if vim.fn.isdirectory(path) ~= 1 then
        print("Not a directory: " .. path)
        return {}
      end

      local pattern = ""
      if string.sub(path, -1) ~= "/" then
        pattern = pattern .. "/"
      end
      pattern = pattern .. "**/*"
      return {
        -- vim.fn.expandcmd is taken from the "shell" builtin template; without it pre-commit
        -- skips all the files in the directory
        cmd = vim.fn.expandcmd("pre-commit run --files " .. path .. pattern),
      }
    end,
    desc = "Run pre-commit on the directory opened in Oil buffer or the current working directory",
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
