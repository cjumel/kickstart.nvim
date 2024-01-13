local utils = require("utils")

return {
  {
    name = "Pre-commit install",
    tags = { "pre-commit" },
    builder = function()
      return {
        cmd = { "pre-commit", "install" },
        name = "Pre-commit install",
      }
    end,
  },
  {
    name = "Pre-commit run file",
    tags = { "pre-commit" },
    builder = function(params)
      local file_path = vim.fn.expand("%:p") -- Current file
      if params.args ~= "" then
        file_path = params.args
      end
      if not utils.path.is_file(file_path) then
        print("Not a file: " .. file_path)
        return {}
      end

      local cmd = { "pre-commit", "run", "--file", file_path }
      local name = "Pre-commit run file"
      local name_suffix = ""
      if params.args ~= "" then
        name_suffix = " (" .. file_path .. ")"
      end

      return {
        cmd = cmd,
        name = name .. name_suffix,
      }
    end,
    _user_command_nargs = "?",
  },
  {
    name = "Pre-commit run directory",
    tags = { "pre-commit" },
    builder = function(params)
      local dir_path = "."
      if params.args ~= "" then
        dir_path = params.args
      end
      if not utils.path.is_directory(dir_path) then
        print("Not a directory: " .. dir_path)
        return {}
      end

      local pattern = ""
      if string.sub(dir_path, -1) ~= "/" then
        pattern = pattern .. "/"
      end
      pattern = pattern .. "**/*"
      -- vim.fn.expandcmd is taken from the "shell" builtin template; without it pre-commit
      -- skips all the files in the directory
      local cmd = vim.fn.expandcmd("pre-commit run --files " .. dir_path .. pattern)
      local name = "Pre-commit run directory"
      local name_suffix = ""
      if params.args ~= "" then
        name_suffix = " (" .. dir_path .. ")"
      end

      return {
        cmd = cmd,
        name = name .. name_suffix,
      }
    end,
    _user_command_nargs = "?",
  },
  {
    name = "Pre-commit run all files",
    tags = { "pre-commit" },
    builder = function()
      return {
        cmd = { "pre-commit", "run", "--all-files" },
        name = "Pre-commit run all files",
      }
    end,
  },
}
